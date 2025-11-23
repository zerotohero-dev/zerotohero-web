#!/usr/bin/env bash

# move-to-tips.sh - Move a blog post from inbox to tips
# Usage: ./move-to-tips.sh

set -e

echo "Move post from inbox to tips"
echo ""

# Prompt for slug
read -p "Enter the post slug (filename without .md): " slug

if [ -z "$slug" ]; then
    echo "Error: Slug cannot be empty"
    exit 1
fi

# Define paths
inbox_file="content/inbox/${slug}.md"
tips_file="content/tips/${slug}.md"
nav_file="content/tips/nav.yaml"

# Check if source file exists
if [ ! -f "$inbox_file" ]; then
    echo "Error: File not found: $inbox_file"
    exit 1
fi

# Check if destination file already exists
if [ -f "$tips_file" ]; then
    echo "Error: File already exists in tips: $tips_file"
    exit 1
fi

# Extract title from frontmatter
title=$(awk '/^title = /{gsub(/^title = "|"$/, ""); print; exit}' "$inbox_file")

if [ -z "$title" ]; then
    echo "Error: Could not extract title from $inbox_file"
    exit 1
fi

echo ""
echo "Found post: $title"
echo "Moving from: $inbox_file"
echo "Moving to: $tips_file"
echo ""

# Add "tips" tag if not present
if grep -q 'tags = \[' "$inbox_file"; then
    # Check if "tips" tag already exists
    if grep 'tags = \[' "$inbox_file" | grep -q '"tips"'; then
        echo "Tag 'tips' already present"
    else
        echo "Adding 'tips' tag..."
        # Extract current tags line
        tags_line=$(grep 'tags = \[' "$inbox_file")

        # Add "tips" to the tags array
        if echo "$tags_line" | grep -q '\[\]'; then
            # Empty tags array
            new_tags_line='tags = ["tips"]'
        else
            # Add tips to existing tags
            new_tags_line=$(echo "$tags_line" | sed 's/\[/["tips", /')
        fi

        # Replace the tags line in the file
        sed -i.bak "s|tags = \[.*\]|$new_tags_line|" "$inbox_file"
        rm "${inbox_file}.bak"
    fi
else
    echo "Warning: No tags line found in frontmatter"
fi

# Append to nav.yaml
echo "Updating $nav_file..."
echo "- name: \"$title\"" >> "$nav_file"
echo "  url: \"@/tips/${slug}.md\"" >> "$nav_file"

# Move the file
echo "Moving file..."
mv "$inbox_file" "$tips_file"

echo ""
echo "Success! Post moved to tips section."
echo "File location: $tips_file"
echo "Updated nav: $nav_file"
echo ""
echo "You can now run 'make serve' to preview the changes."
