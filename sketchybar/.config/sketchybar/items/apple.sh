#!/bin/bash

POPUP_OFF='sketchybar --set apple.logo popup.drawing=off'
POPUP_CLICK_SCRIPT='sketchybar --set $NAME popup.drawing=toggle'

apple_logo=(
        icon=
        icon.font="$FONT:Bold:16.0"
        icon.color=$RED
        padding_right=15
        label.drawing=off
        click_script="$POPUP_CLICK_SCRIPT"
        popup.height=35
)

apple_prefs=(
        icon=
        icon.font="$FONT:Bold:16.0"
        icon.padding_left=10
        icon.padding_right=10
        label.padding_right=10
        label.color="$RED"
        background.height=26
        background.corner_radius="$CORNER_RADIUS"
        background.padding_right=5
        background.border_width="$BORDER_WIDTH"
        background.border_color="$RED"
        background.color="$BAR_COLOR"
        label="Preferences"
        click_script="open -a 'System Preferences'; $POPUP_OFF"
)

apple_activity=(
        icon=󰈞
        icon.font="$FONT:Bold:16.0"
        icon.padding_left=10
        icon.padding_right=10
        label.padding_right=10
        label.color="$RED"
        background.height=26
        background.corner_radius="$CORNER_RADIUS"
        background.padding_right=5
        background.border_width="$BORDER_WIDTH"
        background.border_color="$RED"
        background.color="$BAR_COLOR" label="Activity"
        click_script="open -a 'Activity Monitor'; $POPUP_OFF"
)

apple_lock=(
        icon=
        icon.font="$FONT:Bold:16.0"
        icon.padding_left=10
        icon.padding_right=10
        label.padding_right=10
        label.color="$RED"
        background.height=26
        background.corner_radius="$CORNER_RADIUS"
        background.padding_right=5
        background.border_width="$BORDER_WIDTH"
        background.border_color="$RED"
        background.color="$BAR_COLOR" label="Lock Screen"
        click_script="pmset displaysleepnow; $POPUP_OFF"
)

apple_logout=(
        icon=
        icon.font="$FONT:Bold:16.0"
        icon.padding_left=10
        icon.padding_right=10
        label.padding_right=10
        label.color="$RED"
        background.height=26
        background.corner_radius="$CORNER_RADIUS"
        background.padding_right=5
        background.border_width="$BORDER_WIDTH"
        background.border_color="$RED"
        background.color="$BAR_COLOR" label="Logout"
        click_script="osascript -e 'tell application \
                \"System Events\" to keystroke \"q\" \
                using {command down,shift down}';
                        $POPUP_OFF"
)

sketchybar --add item apple.logo left \
        --set apple.logo "${apple_logo[@]}" \
        --add item apple.prefs popup.apple.logo \
        --set apple.prefs "${apple_prefs[@]}" \
        \
        --add item apple.activity popup.apple.logo \
        --set apple.activity "${apple_activity[@]}" \
        \
        --add item apple.logout popup.apple.logo \
        --set apple.logout "${apple_logout[@]}" \
        \
        --add item apple.lock popup.apple.logo \
        --set apple.lock "${apple_lock[@]}"
