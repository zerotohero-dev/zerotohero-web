#!/usr/bin/env bash

# apply-tags-from-file.sh - Apply tags to posts from a slug list file
# Usage: ./apply-tags-from-file.sh <tag-name> <slug-file>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <tag-name> <slug-file>"
    echo ""
    echo "Example:"
    echo "  $0 architecture tag-files/architecture.txt"
    exit 1
fi

TAG_NAME="$1"
SLUG_FILE="$2"

if [ ! -f "$SLUG_FILE" ]; then
    echo "Error: Slug file '$SLUG_FILE' not found"
    exit 1
fi

echo "Applying tag '$TAG_NAME' to posts from '$SLUG_FILE'"
echo ""

# Track statistics
total_slugs=0
files_found=0
files_modified=0
files_not_found=0

# Read slugs from file
while IFS= read -r slug; do
    # Skip empty lines
    [ -z "$slug" ] && continue

    total_slugs=$((total_slugs + 1))

    # Find the markdown file
    file=$(find content -name "${slug}.md" -type f 2>/dev/null | head -1)

    if [ -z "$file" ]; then
        echo "  ⚠ Not found: $slug"
        files_not_found=$((files_not_found + 1))
        continue
    fi

    files_found=$((files_found + 1))

    # Get line number of second +++
    second_plus=$(grep -n "^+++" "$file" | sed -n '2p' | cut -d: -f1)

    if [ -z "$second_plus" ]; then
        echo "  ⚠ No frontmatter: $slug"
        continue
    fi

    # Extract frontmatter and body
    frontmatter=$(head -n "$second_plus" "$file")
    body=$(tail -n +$((second_plus + 1)) "$file")

    # Extract tags line
    tags_line=$(echo "$frontmatter" | grep "^tags = ")

    if [ -z "$tags_line" ]; then
        echo "  ⚠ No tags line: $slug"
        continue
    fi

    # Check if tag already exists
    if echo "$tags_line" | grep -q "\"$TAG_NAME\""; then
        echo "  ✓ Already has tag: $slug"
        continue
    fi

    # Add the tag
    if echo "$tags_line" | grep -q "tags = \[\]"; then
        # Empty tag array
        new_tags_line="tags = [\"$TAG_NAME\"]"
    else
        # Add to existing tags
        new_tags_line=$(echo "$tags_line" | sed "s/\]$/, \"$TAG_NAME\"]/")
    fi

    # Replace tags line in frontmatter
    new_frontmatter=$(echo "$frontmatter" | sed "s|^tags = .*|$new_tags_line|")

    # Write new file
    temp_file=$(mktemp)
    echo "$new_frontmatter" > "$temp_file"
    echo "$body" >> "$temp_file"
    mv "$temp_file" "$file"

    files_modified=$((files_modified + 1))
    echo "  ✓ Tagged: $slug"

done < "$SLUG_FILE"

echo ""
echo "Summary:"
echo "  Total slugs: $total_slugs"
echo "  Files found: $files_found"
echo "  Files modified: $files_modified"
echo "  Files not found: $files_not_found"

if [ $files_modified -gt 0 ]; then
    echo ""
    echo "Running normalization to remove duplicates..."
    ./hack/normalize-tags.sh
fi
