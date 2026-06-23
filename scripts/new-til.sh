#!/usr/bin/env bash
# Interactively create a new TIL post using gum.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TILS_DIR="$ROOT_DIR/tils"

if ! command -v gum >/dev/null 2>&1; then
	echo "Error: gum is not installed. Install it from https://github.com/charmbracelet/gum" >&2
	exit 1
fi

gum style --foreground 212 --bold "✨ New TIL"

title=$(gum input --placeholder "Title of your TIL" --header "Title")
if [ -z "$title" ]; then
	echo "Error: title cannot be empty" >&2
	exit 1
fi

slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
filename="$TILS_DIR/$slug.md"

if [ -e "$filename" ]; then
	echo "Error: $filename already exists" >&2
	exit 1
fi

existing_tags=$(grep -hoE '^tags: \[[^]]*\]' "$TILS_DIR"/*.md 2>/dev/null \
	| sed -E 's/^tags: \[(.*)\]$/\1/' \
	| tr ',' '\n' \
	| sed -E 's/^[[:space:]]+|[[:space:]]+$//' \
	| sort -u \
	| grep -v '^$')

selected_tags=$(printf '%s\n' "$existing_tags" | gum choose --no-limit --header "Pick existing tags (space to select, enter to confirm; leave empty to skip)" || true)

new_tags=$(gum input --placeholder "new-tag-1, new-tag-2" --header "Add any new tags (comma separated, optional)")

all_tags=$(printf '%s\n%s\n' "$selected_tags" "$new_tags" \
	| tr ',' '\n' \
	| sed -E 's/^[[:space:]]+|[[:space:]]+$//' \
	| grep -v '^$' \
	| sort -u \
	| paste -sd, - \
	| sed -E 's/,/, /g')

date=$(date +%Y-%m-%d)

{
	printf '%s\n' '---'
	printf 'title: "%s"\n' "$title"
	printf 'tags: [%s]\n' "$all_tags"
	printf 'date: %s\n' "$date"
	printf '%s\n' '---'
	printf '\n'
} > "$filename"

gum style --foreground 212 "Created $filename"

if gum confirm "Open it in \$EDITOR now?"; then
	"${EDITOR:-vi}" "$filename"
fi
