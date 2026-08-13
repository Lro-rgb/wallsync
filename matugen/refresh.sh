#!/usr/bin/env bash
matugen image "$1" --type scheme-vibrant --source-color-index 0
hyprctl reload
pkill -SIGUSR2 waybar
