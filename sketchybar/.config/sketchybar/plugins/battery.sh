#!/bin/sh

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
        exit 0
fi

case "${PERCENTAGE}" in
9[0-9] | 100)
        ICON=$BATTERY_100
        ;;
[6-8][0-9])
        ICON=$BATTERY_75
        ;;
[3-5][0-9])
        ICON=$BATTERY_50
        ;;
[1-2][0-9])
        ICON=$BATTERY_25
        COLOR=$ORANGE
        ;;
*)
        ICON=$BATTERY_0
        COLOR=$RED
        ;;
esac

if [[ "$CHARGING" != "" ]]; then
        ICON=""
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
