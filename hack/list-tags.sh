#!/bin/bash

echo "Analyzing blog tags..."
echo ""

# Temporary file for results
temp_file=$(mktemp)

# Find all markdown files and extract tags
find content -name "*.md" -type f | while read file; do
    # Extract only the TOML frontmatter (between first two +++ markers)
    # Using awk to stop after second +++
    awk 'BEGIN {count=0} /^\+\+\+$/ {count++; if(count>2) exit} {print}' "$file" | \
    grep -A1 "^\[taxonomies\]" | grep "^tags = " | \
    # Remove the "tags = [" prefix and "]" suffix
    sed 's/tags = \[//;s/\]//' | \
    # Split by comma and clean up quotes and spaces
    tr ',' '\n' | sed 's/^[[:space:]]*"//;s/"[[:space:]]*$//' | xargs -n1 | grep -v '^$'
done | \
# Sort and count
sort | uniq -c | \
# Sort by frequency (descending)
sort -rn > "$temp_file"

# Display results
echo "Count Tag"
echo "----- ----"
awk '{printf "%-5s %s\n", $1, $2}' "$temp_file"

# Summary
echo ""
total_unique=$(wc -l < "$temp_file" | xargs)
total_usage=$(awk '{sum += $1} END {print sum}' "$temp_file")
echo "Total unique tags: $total_unique"
echo "Total tag usage: $total_usage"

# Cleanup
rm "$temp_file"
