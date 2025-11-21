+++
#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

title = "A Frictionless Blog Workflow"
date = "2025-11-21"

[taxonomies]
tags = ["tips", "blogging", "workflow", "content-creation"]
+++

## Introduction

If you're running a static blog with [Zola](https://www.getzola.org/), you know 
the drill: create a markdown file, add the frontmatter, remember the correct 
TOML format, generate a slug from the title, put it in the proper directory, 
commit, build, and push. 

It's not complicated, but it's **friction**. And the last thing I need nowadays
is friction: I have a lot of high-priority, high-impact tasks, and I
seldom find enough time to create a blog post. So, even when I **exactly** know
what to post, I procrastinate due to the very thought of "organizing" stuff.

So, I wanted to make my blogging as frictionless as possible. Just run a 
command, answer a few questions, and start writing: No context switching, 
no remembering file formats, no manual slug generation.

Here is my current workflow:

## How Things Were Before

Every time I wanted to write a blog post, I had to:

1. Manually create a markdown file with the correct naming convention
2. Copy-paste the TOML frontmatter template
3. Remember which category to put it in
4. Manually generate a URL-friendly slug from the title
5. Format tags correctly
6. Remember the date format
7. Build with Zola
8. Commit and push to deploy

That's too many steps. The barrier to entry was high enough that I'd almost
always skip writing altogether.

## Let's Hack This

So, I created a simple `Makefile` with a shell script that handles everything 
interactively. Now the workflow is:

```bash
make new    # Create a new post
make serve  # Preview locally
make deploy # Build and push to production
```

That's it. Three commands for the entire workflow.

## Creating New Posts

The `make new` command runs an interactive script that:

1. **Asks for a title**: And I just type naturally
2. **Shows category descriptions**: So I know where it belongs
3. **Prompts for tags**: Comma-separated, parsed automatically
4. **Generates everything**: Slug, frontmatter, file structure

Here's what the interaction looks like for this very blog post:

```
$ make new
Creating a new blog post...

Title: A Frictionless Blog Workflow

Available categories:
  1) top-of-mind    - Random thoughts and musings (brain dump)
  2) inbox          - General content (default)
  3) highlights     - Leadership and non-technical aspects
  4) tips           - Useful tips, tricks, and code snippets
  5) roadmap        - Career guidance, resources, life lessons
  6) zero-to-prod   - Production-ready system tutorials
  7) spire          - SPIFFE and SPIRE articles
Choose category (1-7) [default: 2]: 4

Tags (comma-separated): blogging, workflow, content-creation

Created: /Users/volkan/<truncated...>/a-frictionless-blog-workflow.md
```

The script automatically:
* Converts the title to a URL-friendly slug (`a-frictionless-blog-workflow`)
* Generates today's date in the correct format
* Creates the file in the correct directory
* Adds proper TOML frontmatter
* Includes the category as a default tag
* Outputs an absolute path that I can click to open

Here is a list of all `make` targets so far:

```makefile
make help    # Show all available commands
make new     # Create a new blog post interactively
make build   # Build the site with Zola
make serve   # Start local dev server
make deploy  # Build and push to production
make clean   # Remove build artifacts
```

### Publish

I just do a `make deploy`... and done.


```bash
$ make deploy
Building site...
Build complete! Output in ./public/
Deploying to production...
Commit message: Add frictionless workflow post
Deployed successfully!
```

It builds with `zola`, prompts for a commit message, and pushes everything 
in one command.

## The Implementation

Here is the `new-post.sh` that handles all the logic:

```bash
#!/bin/bash

# Interactive prompts
read -p "Title: " title
read -p "Choose category (1-7) [default: 2]: " category_num
read -p "Tags (comma-separated): " tags

# Generate slug from title
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | \
       sed 's/[^a-z0-9]/-/g' | \
       sed 's/--*/-/g' | \
       sed 's/^-//' | sed 's/-$//')

# Create file with proper frontmatter
cat > "$filename" <<EOF
+++
title = "$title"
date = "$(date +%Y-%m-%d)"
[taxonomies]
tags = [$tag_list]
+++

## Introduction

Write your blog post here...
EOF
```

The Makefile just delegates to the script:

```makefile
new: ## Create a new blog post interactively
	@./new-post.sh
```

## Benefits

Well, yes, it's not rocket surgery, but anything that minimizes friction is
a step towards better user experience. And that helps a lot, especially when
the user is busy as a bumblebee.

Automation ftw! The workflow gets out of my way and lets me focus on writing.

* No more "I'll write it later" because setup is annoying
* No more typos in frontmatter
* No more forgotten tags or wrong categories
* No more manual slug generation
* Publishing is literally one command

When the right thing is also the easy thing, it is **delightful**.

And I think that's the whole point.

## Use the Source, Luke

As I improve this script over time, the latest version will always be available 
in this blog's repository:

* [**Zero to Hero** on GitHub](https://github.com/zerotohero-dev/zerotohero-web)

Check out the `Makefile` and `new-post.sh` in the root directory, and feel free
to adapt it to your own workflow.

## Links and Further Reference

* [Zola Static Site Generator](https://www.getzola.org/)
* [GNU Make Manual](https://www.gnu.org/software/make/manual/make.html)
