+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "Bulk Import Bookmarks to Shiori: A Simple Bash Script Solution"
description = "Bulk Import Bookmarks to Shiori: A Simple Bash Script Solution"
date = "2025-06-22"

[taxonomies]
tags = ["inbox","shiori","tips","cli","linux"]
+++

If you're like me and have accumulated hundreds of bookmarks across various
services, migrating them to a self-hosted solution like 
[**Shiori**](https://github.com/go-shiori/shiori) can feel daunting. While 
**Shiori**'s simplicity is one of its strengths, importing bookmarks one by one 
through the web UI or CLI can be time-consuming.

In this post, I'll share a bash script that automates the bulk import process, 
making it easy to migrate your entire bookmark collection to **Shiori** in 
minutes and finally break free from the "social" bookmarking ecosystem.

## What is Shiori?

[Shiori](https://github.com/go-shiori/shiori) is a simple, self-hosted bookmark 
manager written in [Go](https://go.dev/). I like to call it my 
"*antisocial bookmark manager*" because it's the complete opposite of modern, 
social-media-influenced bookmarking services. There are no social features, 
no "trending" sections, no algorithmic recommendations, and definitely 
no tracking. 

It's just you and your bookmarks, exactly how it should be.

Think of Shiori as your personal library: A quiet, private space where you can 
save and organize content that matters to you, without the noise and 
distractions of the modern web.

## Why I Chose Shiori Over Traditional Services

After years of using various "*as a service*" bookmark managers 
(Pocket, Instapaper, Pinboard, and others), I made the switch to **Shiori**.

Here is "why" in a nutshell:

### Complete Privacy and Control

Your bookmarks reveal a lot about your interests, research, and thought 
processes. With Shiori being self-hosted, your data never leaves your server,
or your laptop, if you prefer to host your bookmarks locally. 

No company is analyzing your reading habits, selling your data, or using it to 
train AI models.

### True Offline Access

Shiori doesn't just save links - it creates full offline archives of web pages. 

This means:
* Content remains accessible even if the original site goes down
* No more "404 Page Not Found" disappointments
* Read your saved articles without an internet connection
*Protection against content changes or removals

### No Vendor Lock-in

With traditional services, you're at the mercy of:

* Pricing changes (*remember when Pocket introduced Pocket Premium?*)
* Feature removals (*RIP Google Reader*)
* Service shutdowns (*Delicious, anyone?*)
* API restrictions and rate limits

With **Shiori**, you own your data and the software. It's open source, so even 
if development stops, your bookmarks remain accessible.

### Clean, Distraction-Free Interface

Unlike modern services that push "recommended content" or "what's trending," 
**Shiori** presents only what you've saved. No algorithmic feed, no social 
features trying to increase engagement—just a clean, searchable list of 
your bookmarks.

### Lightweight and Fast

Running on a simple SQLite database (*or, PostgreSQL/MySQL, if you prefer*), 
**Shiori** is incredibly lightweight. It runs comfortably on a 
Raspberry Pi, doesn't require complex infrastructure, and starts up in seconds.

### Developer-Friendly

With a proper CLI interface and straightforward database schema, **Shiori** 
plays well with scripts and automation. You can easily:

* Bulk import/export bookmarks
* Integrate with other tools
* Create custom workflows
* Automate bookmark management

## The Migration Challenge

Shiori provides several ways to add bookmarks:

* Through the web interface (*one at a time*)
* Using the CLI command `shiori add <url>` (*also one at a time*)
* Importing from browsers (*limited format support*)

But what if you have a simple text file with hundreds of URLs? Or what if 
you're migrating from another service that exports to a basic list format? 

That's where automation comes in handy.

## The Solution: A Bulk Import Script

I've created a bash script that:

* Reads URLs from a text file (*one URL per line*)
* Adds each bookmark to Shiori automatically
* Tracks success/failure statistics
* Logs errors for troubleshooting
* Provides progress feedback during import

Here's the complete script:

```bash
#!/bin/bash

# Script to bulk import links to Shiori
# Usage: ./import.sh <links_file.txt>

LINKS_FILE="./links.txt"
if [ $# -eq 0 ]; then
  echo "Usage: $0 <links_file.txt>"
  echo "Defaulting to ./links.txt"
else 
  LINKS_FILE="$1"
fi

# Check if the file exists
if [ ! -f "$LINKS_FILE" ]; then
  echo "Error: File '$LINKS_FILE' not found!"
  exit 1
fi

# Check if shiori is in PATH
if ! command -v shiori &> /dev/null; then
  echo "Error: shiori command not found in PATH!"
  echo "Please ensure shiori binary is accessible"
  exit 1
fi

# Counter variables
total=0
success=0
failed=0

# Log file for errors
ERROR_LOG="shiori_import_errors_$(date +%Y%m%d_%H%M%S).log"

echo "Starting Shiori import from: $LINKS_FILE"
echo "Errors will be logged to: $ERROR_LOG"
echo "----------------------------------------"

# Read the file line by line
while IFS= read -r url || [ -n "$url" ]; do
  # Skip empty lines and lines starting with #
  if [[ -z "$url" ]] || [[ "$url" =~ ^[[:space:]]*# ]]; then
    continue
  fi

  # Trim whitespace
  url=$(echo "$url" | xargs)

  ((total++))
  echo -n "[$total] Adding: $url ... "

  # Add bookmark to Shiori
  if output=$(shiori add "$url" 2>&1); then
    echo "SUCCESS"
    ((success++))

    # Extract bookmark ID from output (macOS compatible)
    bookmark_id=$(echo "$output" | \
      grep -o 'ID:[[:space:]]*[0-9]*' | grep -o '[0-9]*' || \
      echo "$output" | grep -o 'Added bookmark with ID [0-9]*' | \
      grep -o '[0-9]*$' || \
      echo "$output" | grep -o '[0-9]\+' | head -1)

    if [ -n "$bookmark_id" ]; then
      echo "   → Bookmark ID: $bookmark_id"
    fi
  else
    echo "FAILED"
    ((failed++))

    echo "[$total] Failed to add: $url" >> "$ERROR_LOG"
    echo "Error: $output" >> "$ERROR_LOG"
    echo "----------------------------------------" >> "$ERROR_LOG"
  fi

  # Small delay to avoid overwhelming the server
  sleep 0.5

done < "$LINKS_FILE"

echo "----------------------------------------"
echo "Import completed!"
echo "Total processed: $total"
echo "Successful: $success"
echo "Failed: $failed"

if [ $failed -gt 0 ]; then
  echo ""
  echo "Check $ERROR_LOG for details on failed imports"
fi
```

## How to Use the Script

### 1. Prerequisites

* **Shiori** installed and accessible in your `$PATH`.
* A text file containing URLs (*one per line*).
* Bash shell (*works on Linux, macOS, and WSL*)

### 2. Prepare Your URL List

Create a file called `links.txt` with your bookmarks:

```
https://github.com/go-shiori/shiori
https://news.ycombinator.com/
https://example.com/article
# This is a comment - it will be skipped
https://another-site.com/

# Empty lines are also skipped
https://final-url.com/
```

### 3. Run the Script

Save the script as `import.sh`, make it executable, and run:

```bash
chmod +x import.sh
./import.sh links.txt
```

Or use the default `links.txt` file:

```bash
./import.sh
```

### 4. Monitor Progress

The script provides real-time feedback:

```
Starting Shiori import from: ./links.txt
Errors will be logged to: shiori_import_errors_20250622_184441.log
----------------------------------------
[1] Adding: https://github.com/go-shiori/shiori ... SUCCESS
   → Bookmark ID: 1
[2] Adding: https://news.ycombinator.com/ ... SUCCESS
   → Bookmark ID: 2
[3] Adding: https://invalid-url ... FAILED
----------------------------------------
Import completed!
Total processed: 3
Successful: 2
Failed: 1

Check shiori_import_errors_20250622_184441.log \
  for details on failed imports
```

## Key Features

### Error Handling

The script creates a timestamped log file for any failures, making it easy to 
identify and retry problematic URLs.

### Progress Tracking

Real-time feedback shows exactly which URLs are being processed and their 
import status.

### Comment Support

Lines starting with `#` are treated as comments and skipped, allowing you to 
annotate your URL list.

### Rate Limiting

A 0.5-second delay between imports prevents overwhelming your Shiori instance.

### Cross-Platform Compatibility

The script uses POSIX-compliant commands and works on Linux, macOS, 
and Windows (*via WSL*).

## Extending the Script

### Adding Tags
To add tags during import, modify the shiori command:

```bash
shiori add "$url" -t "imported,to-read" 2>&1
```

### Creating Offline Archives

Depending on your Shiori version, you might be able to create offline 4
archives during import. Check available options with:

```bash
shiori add --help
shiori update --help
```

### Parallel Processing

For faster imports with large lists, you could modify the script to use 
GNU parallel:

```bash
cat links.txt | parallel -j 4 shiori add {}
```

## Troubleshooting

### Command Not Found

If you get "shiori: command not found", ensure Shiori is in your `$PATH`:

```bash
which shiori
# Should output something like: /usr/local/bin/shiori
```

### Permission Denied

Make sure the script is executable:

```bash
chmod +x import.sh
```

### Special Characters in URLs

The script handles most URLs correctly, but if you have URLs with special 
characters, ensure they're properly encoded.

## Conclusion

This simple bash script has saved me hours of manual work when migrating 
bookmarks to Shiori. It's a great example of how a little automation can 
streamline repetitive tasks.

The script is intentionally kept simple and focused on the core functionality. 
Feel free to modify it for your specific needs - perhaps adding custom titles, 
excerpts, or integrating with other tools in your workflow.

Happy bookmarking 🔖.
