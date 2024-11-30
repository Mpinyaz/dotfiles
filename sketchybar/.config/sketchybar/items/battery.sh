#!/usr/bin/env bash

COLOR="$CYAN"

sketchybar --add item battery right \
        --set battery \
        update_freq=120 \
        icon.font="$FONT" \
        icon.padding_left=10 \
        icon.padding_right=10 \
        label.padding_right=10 \
        label.color="$COLOR" \
        background.height=26 \
        background.corner_radius="$CORNER_RADIUS" \
        background.padding_right=5 \
        background.border_width="$BORDER_WIDTH" \
        background.border_color="$COLOR" \
        background.color="$BAR_COLOR" \
        script="$PLUGIN_DIR/battery.sh" \
        --subscribe battery system_woke power_source_change
