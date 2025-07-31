#!/bin/bash

# Get current profile
current=$(powerprofilesctl get)

# Define icons for each profile
case $current in
    "power-saver")
        icon=""
        ;;
    "balanced")
        icon=""
        ;;
    "performance")
        icon=""
        ;;
    *)
        icon=""
        ;;
esac

# Output for waybar
echo "{\"text\": \"$icon $current\", \"tooltip\": \"Power Profile: $current\", \"class\": \"$current\"}"
