#!/usr/bin/bash

# sketchybar -m --add item network_up right \
#         --set network_up label.font="$FONT:Bold:20.0" \
#         label="Hello" \
#         icon.color="$RED" \
#         icon.font="$FONT:Bold:20.0" \
#         icon= \
#         icon.highlight_color="$GREEN" \
#         icon.padding_right=$PADDING \
#         icon.padding_left=20 \
#         label.padding_right=$PADDING \
#         width=100 \
#         update_freq=1 \
#         script="$PLUGIN_DIR/network.sh" \
#         --add item network_down right \
#         --set network_down label.font="$FONT:Bold:20.0" \
#         icon.font="$FONT:Bold:20.0" \
#         icon= \
#         icon.color=$GREEN \
#         icon.padding_right=$PADDING \
#         icon.padding_left=$PADDING \
#         label.padding_right=$PADDING \
#         width=100 \
#         update_freq=1

sketchybar -m --add item network_up right \
        --set network_up label.font="SF Pro:Heavy:9" \
        icon.font="$FONT" \
        icon="" \
        icon.highlight_color=0xff8b0a0d \
        y_offset=5 \
        width=0 \
        update_freq=2 \
        script="~/.config/sketchybar/plugins/network.sh" \
        \
        --add item network_down right \
        --set network_down label.font="SF Pro:Heavy:9" \
        icon.font="$FONT" \
        icon="" \
        icon.highlight_color=0xff10528c \
        y_offset=-5 \
        --add bracket network_info network_up network_down \
        --set network_info background.color="$BAR_COLOR" \
        background.height=35 \
        background.corner_radius="$CORNER_RADIUS" \
        background.padding_right=60 \
        background.padding_left=60 \
        background.border_width="$BORDER_WIDTH" \
        background.border_color="$YELLOW" \
        background.color="$BAR_COLOR"
