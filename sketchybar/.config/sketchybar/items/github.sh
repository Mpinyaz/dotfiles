#!/bin/bash

POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

github_bell=(
        padding_right=10
        update_freq=180
        icon=$BELL
        icon.font="$FONT:Bold:15.0"
        icon.color=$BLUE
        icon.padding_right=10
        icon.padding_left=10
        label=$LOADING
        label.highlight_color=$GREEN
        label.padding_right=10
        background.corner_radius="$CORNER_RADIUS"
        background.border_width="$BORDER_WIDTH"
        background.border_color="$RED"
        background.color="$BAR_COLOR"
        background.height=26
        background.drawing=on

        popup.align=right
        script="$PLUGIN_DIR/github.sh"
        click_script="$POPUP_CLICK_SCRIPT"
)

github_template=(
        drawing=off
        # background.corner_radius="$CORNER_RADIUS"
        background.border_width="$BORDER_WIDTH"
        background.border_color="$RED"
        background.color="$BAR_COLOR"
        background.height=40
        background.padding_left=10
        icon.background.height=5
        label.padding_right=20
        label.padding_right=20
        icon.padding_left=40
        icon.padding_left=40
        icon.background.y_offset=-12
)

sketchybar --add event github.update \
        --add item github.bell right \
        --set github.bell "${github_bell[@]}" \
        --subscribe github.bell mouse.entered \
        mouse.exited \
        mouse.exited.global \
        system_woke \
        github.update \
        \
        --add item github.template popup.github.bell \
        --set github.template "${github_template[@]}"
