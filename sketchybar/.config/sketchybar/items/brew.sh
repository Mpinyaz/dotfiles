#!/bin/bash

# Trigger the brew_udpate event when brew update or upgrade is run from cmdline
# e.g. via function in .zshrc

brew=(
        icon=􀐛
        icon.padding_right=10
        icon.padding_left=10
        label=?
        label.color="$COLOR"
        label.padding_right=10
        background.height=26
        background.corner_radius="$CORNER_RADIUS"
        background.border_width="$BORDER_WIDTH"
        background.border_color="$YELLOW"
        background.color="$BAR_COLOR"
        background.drawing=on
        script="$PLUGIN_DIR/brew.sh"
)

sketchybar --add event brew_update \
        --add item brew right \
        --set brew "${brew[@]}" \
        --subscribe brew brew_update
