#!/usr/bin/env bash

source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/variables.sh"

sketchybar --set "$NAME" icon="" icon.font="$FONT" label="CPU: $(ps -A -o %cpu | awk '{s+=$1} END {s /= 8} END {printf "%.1f%%\n", s}')"
