#!/usr/bin/env bash

# find-posts-without-images.sh - Find blog posts without header images
# Usage: ./find-posts-without-images.sh

echo "Finding blog posts without header images..."
echo ""

# Track statistics
total_files=0
no_image_count=0

# Process all markdown files
find content -name "*.md" -type f | sort | while read file; do
    total_files=$((total_files + 1))

    # Get line number of second +++
    second_plus=$(grep -n "^+++" "$file" | sed -n '2p' | cut -d: -f1)

    if [ -z "$second_plus" ]; then
        continue
    fi

    # Get the next few lines after the frontmatter (up to 5 lines to check for image)
    # Skip empty lines and look for {{img(
    has_image=false
    line_num=$((second_plus + 1))
    max_check=$((second_plus + 5))

    while [ $line_num -le $max_check ]; do
        line=$(sed -n "${line_num}p" "$file")

        # Skip empty lines
        if [ -n "$line" ]; then
            # Check if line contains {{img(
            if echo "$line" | grep -q "{{img("; then
                has_image=true
                break
            else
                # If we hit non-empty, non-image content, stop checking
                break
            fi
        fi

        line_num=$((line_num + 1))
    done

    if [ "$has_image" = "false" ]; then
        no_image_count=$((no_image_count + 1))
        echo "$file"
    fi
done

echo ""
echo "Summary:"
echo "  Files without header images: $no_image_count"
echo "  Total files processed: $total_files"
