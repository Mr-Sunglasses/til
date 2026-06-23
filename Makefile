PORT ?= 8000

.PHONY: all build dev serve clean new new-i help

TILLER := $(shell which tiller 2>/dev/null)

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

all: build ## Build the static site (default)

define _check_tiller
	@if [ -z "$(TILLER)" ]; then \
		echo "Error: tiller is not installed. Install it from https://github.com/woodruffw/tiller"; \
		exit 1; \
	fi
endef

build: ## Build the static site
	@$(call _check_tiller)
	tiller -i . -o site

dev: ## Generates in 'dev' mode, suitable for local dev HTTP server
	@$(call _check_tiller)
	tiller --dev

serve: dev ## Serve the built site locally
	python3 -m http.server $(PORT) -d site

new: ## Create a new TIL from template; usage: make new title="My Title" tags="tag1, tag2"
	@if [ -z "$(title)" ]; then \
		echo "Usage: make new title=\"Your TIL Title\" tags=\"tag1, tag2\""; \
		exit 1; \
	fi
	@SLUG=$$(echo "$(title)" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-\| -$$//g'); \
	DATE=$$(date +%Y-%m-%d); \
	TAGS=$$(if [ -n "$(tags)" ]; then echo "$(tags)" | sed 's/,/, /g'; else echo "this is a tag, this is an other tag"; fi); \
	FILENAME="tils/$${SLUG}.md"; \
	if [ -f "$$FILENAME" ]; then \
		echo "Error: $$FILENAME already exists"; \
		exit 1; \
	fi; \
	printf '%s\n%s\n%s\n%s\n%s\n\n' '---' "title: \"$(title)\"" "tags: [$$TAGS]" "date: $$DATE" '---' > "$$FILENAME"; \
	echo "Created $$FILENAME"

new-i: ## Interactively create a new TIL using gum
	@./scripts/new-til.sh

clean: ## Remove the generated site directory
	$(RM) -r site/