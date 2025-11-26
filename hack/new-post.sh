#!/bin/bash

echo "Creating a new blog post..."
echo ""

read -p "Title: " title
echo ""

echo "Available categories:"
echo "  1) top-of-mind       - Random thoughts and musings (brain dump)"
echo "  2) inbox             - General content (default)"
echo "  3) highlights        - Leadership and non-technical aspects"
echo "  4) tips              - Useful tips, tricks, and code snippets"
echo "  5) roadmap           - Career guidance, resources, life lessons"
echo "  6) zero-to-prod      - Production-ready system tutorials"
echo "  7) spire             - SPIFFE and SPIRE articles"
echo "  8) content-creation  - Writing, blogging, and content strategy"
echo "  9) go                - Go programming language articles"
read -p "Choose category (1-9) [default: 2]: " category_num
category_num=${category_num:-2}

case $category_num in
    1) category="top-of-mind";;
    2) category="inbox";;
    3) category="highlights";;
    4) category="tips";;
    5) category="roadmap";;
    6) category="zero-to-prod";;
    7) category="spire";;
    8) category="content-creation";;
    9) category="go";;
    *) category="inbox";;
esac

echo ""
read -p "Tags (comma-separated): " tags

# Generate slug from title
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')
filename="content/$category/$slug.md"
date=$(date +%Y-%m-%d)

# Process tags
IFS=',' read -ra tag_array <<< "$tags"
tag_list=""
for tag in "${tag_array[@]}"; do
    tag=$(echo $tag | xargs)
    if [ -n "$tag" ]; then
        if [ -n "$tag_list" ]; then
            tag_list="$tag_list, \"$tag\""
        else
            tag_list="\"$tag\""
        fi
    fi
done

if [ -z "$tag_list" ]; then
    tag_list="\"$category\""
else
    tag_list="\"$category\", $tag_list"
fi

# Create the file
cat > "$filename" <<'EOF'
+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

EOF

cat >> "$filename" <<EOF
title = "$title"
date = "$date"

[taxonomies]
tags = [$tag_list]
+++

## Introduction

Write your blog post here...
EOF

abs_path="$(cd "$(dirname "$filename")" && pwd)/$(basename "$filename")"
echo ""
echo "Created: $abs_path"
echo ""
