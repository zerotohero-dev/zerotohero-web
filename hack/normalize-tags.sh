#!/usr/bin/env bash

# normalize-tags.sh - Remove duplicate tags from frontmatter
# Usage: ./normalize-tags.sh [--dry-run]

DRY_RUN=false

if [ "$1" = "--dry-run" ]; then
    DRY_RUN=true
    echo "DRY RUN MODE - No files will be modified"
    echo ""
fi

echo "Normalizing tags (removing duplicates)..."
echo ""

# Track statistics
total_files=0
modified_files=0
total_removed=0

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

    # Extract tags, deduplicate while preserving order, and reconstruct
    # Count original tags
    original_count=$(echo "$tags_line" | grep -o '"[^"]*"' | wc -l | xargs)

    # Deduplicate using awk to preserve first occurrence order
    tag_list=$(echo "$tags_line" | grep -o '"[^"]*"' | awk '!seen[$0]++' | paste -sd, -)

    # Count deduplicated tags
    new_count=$(echo "$tag_list" | grep -o '"[^"]*"' | wc -l | xargs)

    new_tags_line="tags = [$tag_list]"

    if [ "$tags_line" != "$new_tags_line" ]; then
        modified_files=$((modified_files + 1))
        removed=$((original_count - new_count))
        total_removed=$((total_removed + removed))

        echo "[$modified_files] $file (removed $removed duplicates: $original_count → $new_count tags)"

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

echo ""
echo "Summary:"
echo "  Files processed: $total_files"
echo "  Files modified: $modified_files"
echo "  Total duplicates removed: $total_removed"

if [ "$DRY_RUN" = "true" ]; then
    echo ""
    echo "This was a dry run. Run without --dry-run to apply changes."
fi
