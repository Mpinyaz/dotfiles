#!/bin/bash

COLOR=$RED
source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/variables.sh"
volume_slider=(
        script="$PLUGIN_DIR/volume.sh"
        updates=on
        label.drawing=off
        icon.drawing=off
        slider.highlight_color=$BLUE
        slider.background.height=5
        slider.background.corner_radius=3
        slider.background.color=$RED
        slider.knob=􀀁
        slider.knob.drawing=on
)

volume_icon=(
        click_script="$PLUGIN_DIR/volume_click.sh"
        icon=$VOLUME_100
        icon.width=5
        icon.align=left
        icon.color=$ACCENT_COLOR
        icon.padding_right=30
        icon.padding_left=30
        icon.font="$FONT:Bold:14.0"
        label.width=25
        label.align=left
        label.padding_left=0
        label.padding_right=10
        label.font="$FONT:Bold:14.0"
        background.height=26
        background.corner_radius="$CORNER_RADIUS"
        background.padding_right=5
        background.padding_left=5
        background.border_width="$BORDER_WIDTH"
        background.border_color="$GREEN"
        background.color="$BAR_COLOR"
        background.drawing=on

)

status_bracket=(
        background.color=$BAR_COLOR
        background.border_color=$BAR_COLOR
)

sketchybar --add slider volume right \
        --set volume "${volume_slider[@]}" \
        --subscribe volume volume_change \
        mouse.clicked \
        --add item volume_icon right \
        --set volume_icon "${volume_icon[@]}"
