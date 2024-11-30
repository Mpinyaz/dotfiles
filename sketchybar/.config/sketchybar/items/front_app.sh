#!/bin/bash

sketchybar --add item front_app center \
        --set front_app background.color=$GREEN \
        icon.color=$RED \
        icon.font="sketchybar-app-font:Regular:16.0" \
        icon.padding_left=10 \
        icon.padding_right=10 \
        label.padding_right=10 \
        label.padding_left=5 \
        label.color="$ORANGE" \
        background.height=30 \
        background.corner_radius="$CORNER_RADIUS" \
        background.padding_right=5 \
        background.border_width="$BORDER_WIDTH" \
        background.border_color="$COLOR" \
        background.color="$BAR_COLOR" \
        background.drawing=on \
        script="$PLUGIN_DIR/front_app.sh" \
        --subscribe front_app front_app_switched
