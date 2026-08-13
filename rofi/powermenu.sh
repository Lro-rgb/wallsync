#!/usr/bin/env bash
shutdown=$'\uf011'
reboot=$'\uf01e'
suspend=$'\uf186'
logout=$'\uf08b'

chosen=$(printf "%s\n" "$shutdown" "$reboot" "$suspend" "$logout" | \
    rofi -dmenu \
    -theme ~/.config/rofi/powermenu.rasi)

case $chosen in
    "$shutdown") systemctl poweroff ;;
    "$reboot") systemctl reboot ;;
    "$suspend") systemctl suspend ;;
    "$logout") hyprctl dispatch exit ;;
esac
