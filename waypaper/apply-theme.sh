#!/usr/bin/env bash
CONFIG="$HOME/.config/waypaper/config.ini"
WALLPAPER=$(grep -m1 '^wallpaper' "$CONFIG" | cut -d'=' -f2- | xargs)

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    notify-send "matugen" "Wallpaper nicht gefunden: $WALLPAPER"
    exit 1
fi

matugen image "$WALLPAPER"
