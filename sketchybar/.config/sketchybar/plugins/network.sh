#!/usr/bin/env bash
#
# # Function to get detailed network info
# get_network_details() {
#         if [ "$(uname)" == "Darwin" ]; then
#                 # macOS: Get Wi-Fi details using airport command
#                 interface="en0" # Default Wi-Fi interface
#                 ssid=$(networksetup -getairportnetwork "$interface" 2>/dev/null | awk -F': ' '{print $2}')
#                 ip=$(ipconfig getifaddr "$interface" 2>/dev/null)
#                 gateway=$(netstat -nr | grep "default" | awk '{print $2}')
#                 echo "SSID: ${ssid:-Disconnected}, IP: ${ip:-N/A}, Gateway: ${gateway:-N/A}"
#         elif [ "$(uname)" == "Linux" ]; then
#                 # Linux: Use nmcli for Wi-Fi and IP details
#                 ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2)
#                 ip=$(hostname -I | awk '{print $1}')
#                 gateway=$(ip route | grep default | awk '{print $3}')
#                 echo "SSID: ${ssid:-Disconnected}, IP: ${ip:-N/A}, Gateway: ${gateway:-N/A}"
#         else
#                 echo "Unsupported OS"
#         fi
# }
#
# # Function to get upload and download speeds
# get_network_speeds() {
#         interface=${1:-"en0"}
#         updown=$(ifstat -i "$interface" -b 0.1 1 | tail -n1)
#         down=$(echo "$updown" | awk '{print $1}' | cut -f1 -d ".")
#         up=$(echo "$updown" | awk '{print $2}' | cut -f1 -d ".")
#
#         # Format speeds
#         down_format=$([ "$down" -gt 999 ] && echo "$down" | awk '{printf "%.0f Mbps", $1 / 1000}' || echo "$down" | awk '{printf "%.0f kbps", $1}')
#         up_format=$([ "$up" -gt 999 ] && echo "$up" | awk '{printf "%.0f Mbps", $1 / 1000}' || echo "$up" | awk '{printf "%.0f kbps", $1}')
#         echo "$down_format,$up_format"
# }
#
# # Main script
# INTERFACE=${1:-"en0"} # Default to en0 if no argument is provided
# command -v ifstat >/dev/null 2>&1 || {
#         echo "Error: ifstat is not installed."
#         exit 1
# }
#
# # Get network details
# NETWORK_DETAILS=$(get_network_details)
#
# # Get upload and download speeds
# SPEEDS=$(get_network_speeds "$INTERFACE")
# DOWN_SPEED=$(echo "$SPEEDS" | cut -d',' -f1)
# UP_SPEED=$(echo "$SPEEDS" | cut -d',' -f2)
#
# # Display information in SketchyBar
# sketchybar -m \
#         --set network_down label="$DOWN_SPEED" \
#         --set network_up label="$UP_SPEED"

UPDOWN=$(ifstat -i "en0" -b 0.1 1 | tail -n1)
DOWN=$(echo $UPDOWN | awk "{ print \$1 }" | cut -f1 -d ".")
UP=$(echo $UPDOWN | awk "{ print \$2 }" | cut -f1 -d ".")

DOWN_FORMAT=""
if [ "$DOWN" -gt "999" ]; then
        DOWN_FORMAT=$(echo $DOWN | awk '{ printf "%.0f Mbps", $1 / 1000}')
else
        DOWN_FORMAT=$(echo $DOWN | awk '{ printf "%.0f kbps", $1}')
fi

UP_FORMAT=""
if [ "$UP" -gt "999" ]; then
        UP_FORMAT=$(echo $UP | awk '{ printf "%.0f Mbps", $1 / 1000}')
else
        UP_FORMAT=$(echo $UP | awk '{ printf "%.0f kbps", $1}')
fi

sketchybar -m --set network_down label="$DOWN_FORMAT" icon.highlight=$(if [ "$DOWN" -gt "0" ]; then echo "on"; else echo "off"; fi) \
        --set network_up label="$UP_FORMAT" icon.highlight=$(if [ "$UP" -gt "0" ]; then echo "on"; else echo "off"; fi)
