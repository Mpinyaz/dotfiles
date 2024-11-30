#!/bin/bash

COLOR="$BLUE"
calendar=(
        icon.color="$COLOR"
        icon.padding_left=10
        label.color="$COLOR"
        label.padding_right=10
        background.height=26
        background.corner_radius="$CORNER_RADIUS"
        background.padding_right=5
        background.border_width="$BORDER_WIDTH"
        background.border_color="$COLOR"
        background.color="$BAR_COLOR"
        background.drawing=on
        update_freq=30
        script="$PLUGIN_DIR/calendar.sh"
)

sketchybar --add item calendar right \
        --set calendar "${calendar[@]}" \
        --subscribe calendar system_woke
