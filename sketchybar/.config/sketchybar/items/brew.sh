#!/bin/env bash

source "$HOME/.config/sketchybar/variables.sh"
source "$HOME/.config/sketchybar/icons.sh"
brew=(
        icon=􀐛
        icon.padding_right=10
        icon.padding_left=10
        label=?
        label.color="$COLOR"
        label.padding_right=10
        background.height=26
        update_freq=30
        background.corner_radius="$CORNER_RADIUS"
        click_script="$POPUP_CLICK_SCRIPT"
        background.border_width="$BORDER_WIDTH"
        background.border_color="$MAUVE"
        background.color="$BAR_COLOR"
        script="$PLUGIN_DIR/brew.sh"
)

brew_details=(
        background.padding_left=10
        background.padding_right=10
        label.padding_left=12
        label.padding_right=12
        background.corner_radius="$CORNER_RADIUS"
        background.border_width="$BORDER_WIDTH"
        background.border_color="$MAUVE"
        background.color="$GREEN"

        click_script="sketchybar --set brew popup.drawing=off"
)

sketchybar --add event brew_update \
        --add item brew left \
        --set brew "${brew[@]}" \
        \
        --subscribe brew brew_update \
        mouse.entered \
        mouse.exited \
        mouse.exited.global \
        \
        --add item brew.details popup.brew \
        --set brew.details "${brew_details[@]}"
