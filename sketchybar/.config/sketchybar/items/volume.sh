#!/bin/bash
COLOR=$MAGENTA
sketchybar --add item volume right \
        --set volume script="$PLUGIN_DIR/volume.sh" \
        icon.font="$FONT" \
        icon.color="$COLOR" \
        icon.padding_left=10 \
        label.padding_right=10 \
        label.color="$COLOR" \
        background.height=26 \
        background.corner_radius="$CORNER_RADIUS" \
        background.padding_right=5 \
        background.border_width="$BORDER_WIDTH" \
        background.border_color="$COLOR" \
        background.color="$BAR_COLOR" \
        background.drawing=on \
        --subscribe volume volume_change
