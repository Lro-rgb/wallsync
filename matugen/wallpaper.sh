#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Wallpaper"
THUMBNAIL_DIR="$HOME/.cache/wallpaper-thumbs"
THUMB_SIZE="300x200"

mkdir -p "$THUMBNAIL_DIR"

# Generate thumbnails
for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp}; do
    [ -f "$img" ] || continue
    fname=$(basename "$img")
    thumb="$THUMBNAIL_DIR/$fname.png"
    if [ ! -f "$thumb" ]; then
        convert "$img" -thumbnail "${THUMB_SIZE}^" \
            -gravity center -extent "$THUMB_SIZE" "$thumb"
    fi
done

# Build rofi input
chosen=$(for img in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp}; do
    [ -f "$img" ] || continue
    fname=$(basename "$img")
    thumb="$THUMBNAIL_DIR/$fname.png"
    echo -en "$fname\x00icon\x1f$thumb\n"
done | rofi -dmenu \
    -p "Wallpaper" \
    -theme ~/.config/rofi/wallpaper.rasi \
    -show-icons)

[ -z "$chosen" ] && exit 0

SELECTED="$WALLPAPER_DIR/$chosen"

# Set wallpaper with awww
awww img "$SELECTED" --transition-type fade --transition-duration 1.5

# Run matugen and refresh everything
~/.config/matugen/refresh.sh "$SELECTED"
