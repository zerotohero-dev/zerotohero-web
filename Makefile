# Zero to Hero Blog Makefile
# Makes blogging frictionless!

.PHONY: help new build serve deploy clean tags

help: ## Show this help message
	@echo "Zero to Hero Blog - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

new: ## Create a new blog post interactively
	@./new-post.sh

build: ## Build the site with Zola
	@echo "Building site..."
	zola build
	@echo "Build complete! Output in ./public/"

serve: ## Start local development server
	@echo "Starting development server..."
	@echo "Visit http://127.0.0.1:1111"
	zola serve

deploy: build ## Build and deploy to production (git push)
	@echo "Deploying to production..."
	@if [ -n "$$(git status --porcelain)" ]; then \
		read -p "Commit message: " message; \
		git add .; \
		git commit -m "$$message"; \
		git push; \
		echo "Deployed successfully!"; \
	else \
		echo "No changes to deploy"; \
	fi

tags: ## List all tags with usage frequency
	@./list-tags.sh

merge-tags: ## Merge/rename tags using tag-mappings.txt (use DRY_RUN=1 for preview)
	@if [ "$(DRY_RUN)" = "1" ]; then \
		./merge-tags.sh tag-mappings.txt --dry-run; \
	else \
		./merge-tags.sh tag-mappings.txt; \
	fi

normalize-tags: ## Remove duplicate tags from all posts (use DRY_RUN=1 for preview)
	@if [ "$(DRY_RUN)" = "1" ]; then \
		./normalize-tags.sh --dry-run; \
	else \
		./normalize-tags.sh; \
	fi

find-no-images: ## Find blog posts without header images
	@./find-posts-without-images.sh

clean: ## Clean the public directory
	@echo "Cleaning build artifacts..."
	rm -rf public
	@echo "Clean complete!"
