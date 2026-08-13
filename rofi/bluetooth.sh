#!/usr/bin/env bash
rofi_command="rofi -dmenu -i -p Bluetooth -theme ~/.config/rofi/bluetooth.rasi"

is_powered() { bluetoothctl show | grep -q "Powered: yes"; }
is_connected() { bluetoothctl info "$1" | grep -q "Connected: yes"; }

toggle_power() {
    if is_powered; then
        bluetoothctl power off
        notify-send "Bluetooth" "Ausgeschaltet"
    else
        bluetoothctl power on
        notify-send "Bluetooth" "Eingeschaltet"
    fi
}

scan() {
    notify-send "Bluetooth" "Suche 5 Sekunden..."
    bluetoothctl --timeout 5 scan on
}

device_menu() {
    mac="$1"
    name=$(bluetoothctl info "$mac" | grep "Name" | cut -d ' ' -f2-)
    if is_connected "$mac"; then
        conn_opt="Disconnect"
    else
        conn_opt="Connect"
    fi
    chosen=$(printf "%s\n" "$conn_opt" "Pair" "Trust" "Remove" "← Back" | $rofi_command -p "$name")
    case "$chosen" in
        "Connect") bluetoothctl connect "$mac" ;;
        "Disconnect") bluetoothctl disconnect "$mac" ;;
        "Pair") bluetoothctl pair "$mac" ;;
        "Trust") bluetoothctl trust "$mac" ;;
        "Remove") bluetoothctl remove "$mac" ;;
        "← Back") show_devices ;;
    esac
}

show_devices() {
    declare -A device_map
    menu=""
    while read -r _ mac name; do
        [ -z "$mac" ] && continue
        if is_connected "$mac"; then icon="✓"; else icon=" "; fi
        entry="$icon  $name"
        menu+="$entry"$'\n'
        device_map["$entry"]="$mac"
    done < <(bluetoothctl devices)

    chosen=$(printf "%s← Back\n" "$menu" | $rofi_command -p "Geräte")
    if [ "$chosen" == "← Back" ]; then
        main_menu
    elif [ -n "$chosen" ]; then
        device_menu "${device_map[$chosen]}"
    fi
}

main_menu() {
    if is_powered; then power_opt="⏻  Turn Off"; else power_opt="⏻  Turn On"; fi
    chosen=$(printf "%s\n Scan\n Devices\n" "$power_opt" | $rofi_command)
    case "$chosen" in
        *"Turn On"*|*"Turn Off"*) toggle_power ;;
        *"Scan"*) scan; main_menu ;;
        *"Devices"*) show_devices ;;
    esac
}

main_menu
