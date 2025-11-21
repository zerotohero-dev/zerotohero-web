#!/usr/bin/env bash

# merge-tags.sh - Rename/merge blog tags in frontmatter
# Usage: ./merge-tags.sh <mapping-file> [--dry-run]
#
# Mapping file format (one per line):
#   old-tag -> new-tag
#
# Example:
#   SPIFFE -> spiffe
#   secrets-management -> secrets
#   secret-sharing -> secrets

if [ $# -lt 1 ]; then
    echo "Usage: $0 <mapping-file> [--dry-run]"
    echo ""
    echo "Mapping file format (one per line):"
    echo "  old-tag -> new-tag"
    echo ""
    echo "Example:"
    echo "  SPIFFE -> spiffe"
    echo "  secrets-management -> secrets"
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
        # Try to replace "old_tag" in the tags line
        if echo "$new_tags_line" | grep -q "\"$old_tag\""; then
            new_tags_line=$(echo "$new_tags_line" | sed "s/\"$old_tag\"/\"$new_tag\"/g")
            file_modified=true
            file_replacements=$((file_replacements + 1))
        fi
    done < "$TEMP_MAPPINGS"

    if [ "$file_modified" = "true" ]; then
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
