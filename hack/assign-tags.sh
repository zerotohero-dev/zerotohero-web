#!/usr/bin/env bash

# assign-tags.sh - Assign tags to blog posts by slug
# Usage: ./assign-tags.sh
#
# This script interactively assigns tags to multiple posts:
# 1. Asks for tag(s) to assign (comma-separated)
# 2. Asks for slugs (post filenames without .md extension)
# 3. Assigns tags to matching files
# 4. Normalizes tags (removes duplicates)

echo "Assign Tags to Posts by Slug"
echo "=============================="
echo ""

# Step 1: Get tags to assign
echo "Enter tag(s) to assign (comma-separated, e.g., 'go,security' or 'kubernetes'):"
read -r tags_input

if [ -z "$tags_input" ]; then
    echo "Error: No tags provided"
    exit 1
fi

# Convert comma-separated tags to array
IFS=',' read -ra TAGS <<< "$tags_input"

# Trim whitespace from tags
TAGS_CLEANED=()
for tag in "${TAGS[@]}"; do
    trimmed=$(echo "$tag" | xargs)
    if [ -n "$trimmed" ]; then
        TAGS_CLEANED+=("$trimmed")
    fi
done

if [ ${#TAGS_CLEANED[@]} -eq 0 ]; then
    echo "Error: No valid tags provided"
    exit 1
fi

echo ""
echo "Tags to assign: ${TAGS_CLEANED[*]}"
echo ""

# Step 2: Collect slugs
echo "Enter post slugs (one per line, press Enter on empty line to finish):"
echo "Slugs are filenames without the .md extension (e.g., 'my-blog-post')"
echo ""

SLUGS=()
while true; do
    read -r slug_input

    # Check if empty (user pressed Enter on empty line)
    if [ -z "$slug_input" ]; then
        break
    fi

    # Trim whitespace
    slug=$(echo "$slug_input" | xargs)

    if [ -n "$slug" ]; then
        SLUGS+=("$slug")
        echo "  ✓ Added: $slug"
    fi
done

if [ ${#SLUGS[@]} -eq 0 ]; then
    echo ""
    echo "Error: No slugs provided"
    exit 1
fi

echo ""
echo "=============================="
echo "Summary:"
echo "  Tags: ${TAGS_CLEANED[*]}"
echo "  Posts: ${#SLUGS[@]}"
echo ""
echo "Proceeding to assign tags..."
echo ""

# Step 3: Find and modify files
files_modified=0
files_not_found=0

for slug in "${SLUGS[@]}"; do
    # Find the file (search all content subdirectories)
    file=$(find content -name "${slug}.md" -type f)

    if [ -z "$file" ]; then
        echo "[NOT FOUND] ${slug}.md"
        files_not_found=$((files_not_found + 1))
        continue
    fi

    # Check if file has multiple matches
    file_count=$(echo "$file" | wc -l | xargs)
    if [ "$file_count" -gt 1 ]; then
        echo "[MULTIPLE] ${slug}.md found in multiple locations:"
        echo "$file" | sed 's/^/    /'
        echo "  Skipping - please be more specific"
        files_not_found=$((files_not_found + 1))
        continue
    fi

    # Get the second +++ line number
    second_plus=$(grep -n "^+++" "$file" | sed -n '2p' | cut -d: -f1)

    if [ -z "$second_plus" ]; then
        echo "[ERROR] ${slug}.md - Invalid frontmatter format"
        files_not_found=$((files_not_found + 1))
        continue
    fi

    # Extract frontmatter and body
    frontmatter=$(head -n "$second_plus" "$file")
    body=$(tail -n +$((second_plus + 1)) "$file")

    # Extract current tags line
    tags_line=$(echo "$frontmatter" | grep "^tags = ")

    if [ -z "$tags_line" ]; then
        echo "[ERROR] ${slug}.md - No tags line found"
        files_not_found=$((files_not_found + 1))
        continue
    fi

    # Extract current tags (everything between [ and ])
    current_tags=$(echo "$tags_line" | sed 's/tags = \[//; s/\]//')

    # Add new tags
    new_tags_list="$current_tags"
    for tag in "${TAGS_CLEANED[@]}"; do
        # Check if tag already exists
        if echo "$current_tags" | grep -q "\"$tag\""; then
            continue  # Skip if already present
        fi

        # Add comma if list is not empty
        if [ -n "$new_tags_list" ]; then
            new_tags_list="$new_tags_list,\"$tag\""
        else
            new_tags_list="\"$tag\""
        fi
    done

    # Create new tags line
    new_tags_line="tags = [$new_tags_list]"

    # Replace tags line in frontmatter
    new_frontmatter=$(echo "$frontmatter" | sed "s|^tags = .*|$new_tags_line|")

    # Create temp file
    temp_file=$(mktemp)

    # Write new content
    echo "$new_frontmatter" > "$temp_file"
    echo "$body" >> "$temp_file"

    # Replace original file
    mv "$temp_file" "$file"

    echo "[MODIFIED] ${slug}.md"
    files_modified=$((files_modified + 1))
done

echo ""
echo "=============================="
echo "Summary:"
echo "  Files modified: $files_modified"
echo "  Files not found/skipped: $files_not_found"
echo ""

if [ $files_modified -gt 0 ]; then
    echo "Running tag normalization..."
    ./hack/normalize-tags.sh
    echo ""
    echo "✓ Done! Tags have been assigned and normalized."
else
    echo "No files were modified."
fi
