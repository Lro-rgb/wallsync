#!/bin/bash
waypaper --restore
matugen image "$(cat ~/.config/waypaper/config.ini | grep wallpaper | cut -d= -f2 | tr -d ' ')"
