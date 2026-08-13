#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="/var/lib/regreet-bg"
OUTPUT="$OUTPUT_DIR/background.png"

WALLPAPER=$(awww query 2>/dev/null | grep -oP 'image: \K.*' | head -1)

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    echo "regreet-bg: could not determine current wallpaper" >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"
magick "$WALLPAPER" -resize 2880x -blur 0x8 -strip "$OUTPUT"
