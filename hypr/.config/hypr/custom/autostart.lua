-- Execute your favorite apps at launch
exec_once = 'waybar'
exec_once = 'swaync'
exec_once = 'hypridle'
exec_once = 'qs -c overview'
exec_once = 'feh --bg-fill /home/mpinyaz/wallpaper.webp'

-- Clipboard: history
-- exec_once = "wl-paste --watch cliphist store &"
exec_once = "wl-paste --type text --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'"
exec_once = "wl-paste --type image --watch bash -c 'cliphist store && qs -c $qsConfig ipc call cliphistService update'"
