#!/usr/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"
source "$HOME/.config/sketchybar/icons.sh"
COLOR="$MAGENTA"

sketchybar --add item ram right \
        --set ram \
        update_freq=3 \
        icon.color="$COLOR" \
        icon.padding_left=10 \
        label.color="$COLOR" \
        label.padding_right=10 \
        label.padding_left=10 \
        background.height=26 \
        background.corner_radius="$CORNER_RADIUS" \
        background.padding_right=5 \
        background.border_width="$BORDER_WIDTH" \
        background.border_color="$GREEN" \
        background.color="$BAR_COLOR" \
        background.drawing=on \
        script="$PLUGIN_DIR/ram.sh"
