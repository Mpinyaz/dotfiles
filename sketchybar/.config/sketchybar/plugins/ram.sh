#!/bin/bash

source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/variables.sh"
sketchybar -m --set "$NAME" icon="" icon.font="$FONT" label="RAM: $(memory_pressure | grep "System-wide memory free percentage:" | awk '{ printf("%02.0f\n", 100-$5"%") }')%"
