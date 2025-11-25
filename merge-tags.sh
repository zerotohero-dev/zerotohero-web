#!/usr/bin/env bash

# merge-tags.sh - Rename/merge blog tags in frontmatter
# Usage: ./merge-tags.sh <mapping-file> [--dry-run]
#
# Mapping file format (one per line):
#   old-tag -> new-tag
#   old-tag -> {tag1;tag2;tag3}  (expand to multiple tags)
#
# Example:
#   SPIFFE -> spiffe
#   secrets-management -> secrets
#   journaling -> {ponderings;tips;productivity}

if [ $# -lt 1 ]; then
    echo "Usage: $0 <mapping-file> [--dry-run]"
    echo ""
    echo "Mapping file format (one per line):"
    echo "  old-tag -> new-tag"
    echo "  old-tag -> {tag1;tag2;tag3}  (expand to multiple tags)"
    echo ""
    echo "Example:"
    echo "  SPIFFE -> spiffe"
    echo "  secrets-management -> secrets"
    echo "  journaling -> {ponderings;tips;productivity}"
    exit 1
fi

MAPPING_FILE="$1"
DRY_RUN=false

if [ "$2" = "--dry-run" ]; then
    DRY_RUN=true
    echo "DRY RUN MODE - No files will be modified"
    echo ""
fi

if [ ! -f "$MAPPING_FILE" ]; then
    echo "Error: Mapping file '$MAPPING_FILE' not found"
    exit 1
fi

# Create temp file to store mappings
TEMP_MAPPINGS=$(mktemp)

# Read mapping file
echo "Loaded mappings:"
while IFS= read -r line; do
    # Skip empty lines and comments
    echo "$line" | grep -q "^[[:space:]]*#" && continue
    echo "$line" | grep -q "^[[:space:]]*$" && continue

    # Parse "old -> new" format
    old_tag=$(echo "$line" | sed 's/[[:space:]]*->.*//' | xargs)
    new_tag=$(echo "$line" | sed 's/.*->[[:space:]]*//' | xargs)

    if [ -n "$old_tag" ] && [ -n "$new_tag" ]; then
        echo "$old_tag|$new_tag" >> "$TEMP_MAPPINGS"
        echo "  $old_tag -> $new_tag"
    fi
done < "$MAPPING_FILE"

if [ ! -s "$TEMP_MAPPINGS" ]; then
    echo "Error: No valid mappings found in $MAPPING_FILE"
    rm "$TEMP_MAPPINGS"
    exit 1
fi

echo ""

# Track statistics
total_files=0
modified_files=0
total_replacements=0

# Process all markdown files
find content -name "*.md" -type f | while read file; do
    total_files=$((total_files + 1))

    # Create temp file
    temp_file=$(mktemp)

    # Get line number of second +++
    second_plus=$(grep -n "^+++" "$file" | sed -n '2p' | cut -d: -f1)

    if [ -z "$second_plus" ]; then
        rm "$temp_file"
        continue
    fi

    # Extract frontmatter (including +++ markers)
    frontmatter=$(head -n "$second_plus" "$file")

    # Extract body (everything after second +++)
    body=$(tail -n +$((second_plus + 1)) "$file")

    # Extract tags line from frontmatter
    tags_line=$(echo "$frontmatter" | grep "^tags = ")

    if [ -z "$tags_line" ]; then
        rm "$temp_file"
        continue
    fi

    # Perform replacements
    new_tags_line="$tags_line"
    file_modified=false
    file_replacements=0

    # Read each mapping and apply it
    while IFS='|' read -r old_tag new_tag; do
        # Check if tag exists in the line
        if echo "$new_tags_line" | grep -q "\"$old_tag\""; then

            # Escape sed special characters in old_tag
            old_tag_escaped=$(echo "$old_tag" | sed 's/[\/&]/\\&/g')

            # Handle special DELETE operations
            if [ "$new_tag" = "DELETE_IF_NOT_ALONE" ]; then
                # Count total tags in the line
                tag_count=$(echo "$new_tags_line" | grep -o '"[^"]*"' | wc -l | xargs)

                if [ "$tag_count" -gt 1 ]; then
                    # Remove the tag (and handle comma cleanup)
                    new_tags_line=$(echo "$new_tags_line" | sed "s/, *\"$old_tag_escaped\"//; s/\"$old_tag_escaped\" *, *//")
                    file_modified=true
                    file_replacements=$((file_replacements + 1))
                fi
                # If only one tag, keep it (do nothing)

            elif [ "$new_tag" = "DELETE" ]; then
                # Always remove the tag
                # Check if this is the only tag
                tag_count=$(echo "$new_tags_line" | grep -o '"[^"]*"' | wc -l | xargs)

                if [ "$tag_count" -eq 1 ]; then
                    # Only tag - create empty array
                    new_tags_line="tags = []"
                else
                    # Multiple tags - remove with comma handling
                    new_tags_line=$(echo "$new_tags_line" | sed "s/, *\"$old_tag_escaped\"//; s/\"$old_tag_escaped\" *, *//")
                fi
                file_modified=true
                file_replacements=$((file_replacements + 1))

            else
                # Escape sed special characters in new_tag
                new_tag_escaped=$(echo "$new_tag" | sed 's/[\/&]/\\&/g')

                # Check if new_tag contains multiple targets: {tag1;tag2;tag3}
                if echo "$new_tag" | grep -q "^{.*}$"; then
                    # Extract tags from {tag1;tag2;tag3} format
                    multi_tags=$(echo "$new_tag" | sed 's/^{//; s/}$//; s/;/","/g')
                    # Escape special characters in multi_tags
                    multi_tags_escaped=$(echo "$multi_tags" | sed 's/[\/&]/\\&/g')
                    # Replace old tag with multiple new tags
                    new_tags_line=$(echo "$new_tags_line" | sed "s/\"$old_tag_escaped\"/\"$multi_tags_escaped\"/g")
                else
                    # Normal single replacement
                    new_tags_line=$(echo "$new_tags_line" | sed "s/\"$old_tag_escaped\"/\"$new_tag_escaped\"/g")
                fi
                file_modified=true
                file_replacements=$((file_replacements + 1))
            fi
        fi
    done < "$TEMP_MAPPINGS"

    if [ "$file_modified" = "true" ]; then
        # Deduplicate tags in the new tags line
        # Extract tags, deduplicate, and reconstruct
        tag_list=$(echo "$new_tags_line" | grep -o '"[^"]*"' | sort -u | paste -sd, -)
        new_tags_line="tags = [$tag_list]"

        modified_files=$((modified_files + 1))
        total_replacements=$((total_replacements + file_replacements))

        echo "[$modified_files] $file ($file_replacements replacements)"

        if [ "$DRY_RUN" = "false" ]; then
            # Replace the tags line in frontmatter
            new_frontmatter=$(echo "$frontmatter" | sed "s|^tags = .*|$new_tags_line|")

            # Write new file
            echo "$new_frontmatter" > "$temp_file"
            echo "$body" >> "$temp_file"

            # Replace original file
            mv "$temp_file" "$file"
        fi
    fi

    # Cleanup
    [ -f "$temp_file" ] && rm "$temp_file"
done

# Cleanup
rm "$TEMP_MAPPINGS"

echo ""
echo "Summary:"
echo "  Files processed: $total_files"
echo "  Files modified: $modified_files"
echo "  Total replacements: $total_replacements"

if [ "$DRY_RUN" = "true" ]; then
    echo ""
    echo "This was a dry run. Run without --dry-run to apply changes."
fi
