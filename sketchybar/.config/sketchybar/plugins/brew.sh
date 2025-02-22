#!/usr/bin/env bash
source "$HOME/.config/sketchybar/variables.sh"
source "$HOME/.config/sketchybar/icons.sh"

PREV_COUNT=$(sketchybar --query brew | jq -r .popup.items | grep ".package*" -c)

TEXT=0xffcad3f5
render_bar_item() {
        case "$COUNT" in
        [3-5][0-9])
                COLOR=$PEACH
                ;;
        [1-2][0-9])
                COLOR=$YELLOW
                ;;
        [1-9])
                COLOR=$TEXT
                ;;
        0)
                COLOR=$GREEN
                COUNT=􀆅
                ;;
        esac

        sketchybar --set "$NAME" label="$COUNT" icon.color="$COLOR"
}

add_outdated_header() {
        brew_header=(
                label="$(echo -e 'Outdated Brews')"
                label.font="$FONT:Bold:16.0"
                label.align=left
                icon.drawing=off
                click_script="sketchybar --set $NAME popup.drawing=off"
        )

        sketchybar --set brew.details "${brew_header[@]}"

}

render_popup() {
        add_outdated_header

        COUNTER=0
        sketchybar --remove '/brew.package\.*/'

        if [[ -n "$OUTDATED" ]]; then
                while IFS= read -r package; do

                        brew_package=(
                                label="$package"
                                label.align=right
                                background.padding_left=10
                                background.padding_right=10
                                label.padding_left=12
                                label.padding_right=12
                                background.corner_radius="$CORNER_RADIUS"
                                background.border_width="$BORDER_WIDTH"
                                background.border_color="$MAUVE"
                                background.color="$BAR_COLOR"
                                icon.drawing=off
                                click_script="sketchybar --set $NAME popup.drawing=off"

                        )
                        item=brew.package."$COUNTER"

                        sketchybar --add item "$item" popup."$NAME" \
                                --set "$item" "${brew_package[@]}"

                        COUNTER=$((COUNTER + 1))

                done <<<"$(echo -n "$OUTDATED" | grep '^')"
        fi
}

update() {
        brew update
        COLOR=$RED
        OUTDATED=$(brew outdated)
        COUNT=$(echo -n "$OUTDATED" | grep -c '^')

        render_bar_item
        render_popup

        if [ "$COUNT" -ne "$PREV_COUNT" ] 2>/dev/null || [ "$SENDER" = "forced" ]; then
                sketchybar --animate tanh 15 --set "$NAME" label.y_offset=5 label.y_offset=0
        fi
}

popup() {
        if [[ "$PREV_COUNT" -gt 0 ]]; then
                sketchybar --set "$NAME" popup.drawing="$1"
        else
                sketchybar --set "$NAME" popup.drawing=off
        fi

}

case "$SENDER" in
"routine" | "forced")
        update
        ;;
"mouse.entered")
        popup on
        ;;
"mouse.exited" | "mouse.exited.global")
        popup off
        ;;
"mouse.clicked")
        popup toggle
        ;;
esac
