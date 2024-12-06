#!/usr/bin/bash

sketchybar -m --add item network_up right \
        --set network_up label.font="$FONT:Bold:20.0" \
        label="Hello" \
        icon.color="$RED" \
        icon.font="$FONT:Bold:20.0" \
        icon= \
        icon.highlight_color="$GREEN" \
        icon.padding_right=$PADDING \
        icon.padding_left=20 \
        label.padding_right=$PADDING \
        width=100 \
        update_freq=1 \
        script="$PLUGIN_DIR/network.sh" \
        --add item network_down right \
        --set network_down label.font="$FONT:Bold:20.0" \
        icon.font="$FONT:Bold:20.0" \
        icon= \
        icon.color=$GREEN \
        icon.padding_right=$PADDING \
        icon.padding_left=$PADDING \
        label.padding_right=$PADDING \
        width=100 \
        update_freq=1
sketchybar --add bracket network_info network_up network_down \
        --set network_info background.color=$BAR_COLOR \
        background.height=26 \
        background.corner_radius="$CORNER_RADIUS" \
        background.padding_right="$PADDING" \
        background.padding_left="$PADDING" \
        background.border_width="$BORDER_WIDTH" \
        background.border_color="$COLOR" \
        background.color="$BAR_COLOR"
