#!/bin/bash
if [ "$1" = "menu" ]; then
    # Show menu with rofi
    choice=$(echo -e "power-saver\nbalanced\nperformance" | rofi -dmenu -p "Power Profile:")
    if [ -n "$choice" ]; then
        powerprofilesctl set "$choice"
        notify-send "Power Profile" "Switched to $choice"
  fi
else
    current=$(powerprofilesctl get)
    case $current in
        "power-saver") powerprofilesctl set balanced ;;
        "balanced") powerprofilesctl set performance ;;
        "performance") powerprofilesctl set power-saver ;;
  esac
fi
