#!/bin/bash

current=$(powerprofilesctl get)

case $current in
    "power-saver")
        powerprofilesctl set balanced
        notify-send "Power Profile" "Switched to Balanced" -i battery-good
        ;;
    "balanced")
        powerprofilesctl set performance
        notify-send "Power Profile" "Switched to Performance" -i battery-full-charging
        ;;
    "performance")
        powerprofilesctl set power-saver
        notify-send "Power Profile" "Switched to Power Saver" -i battery-low
        ;;
esac
