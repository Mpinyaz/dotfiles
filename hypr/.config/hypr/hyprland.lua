----------------------------------------------------------------------
-- SOURCES
----------------------------------------------------------------------
require 'custom/keybinds'
require 'custom/window'
require 'custom/layouts'
require 'custom/colors'
require 'custom/input'
require 'custom/env'
require 'custom.gesture'
require 'custom/misc'

------------------
---- MONITORS ----
------------------
hl.monitor {
  output = '',
  mode = 'preferred',
  position = 'auto',
  scale = 'auto',
}

---------------------
---- MY PROGRAMS ----
---------------------
local terminal = 'ghostty'
local fileManager = 'thunar'
local menu = 'hyprlauncher'

-------------------
---- AUTOSTART ----
-------------------
hl.on('hyprland.start', function()
  hl.exec_cmd 'dbus-update-activation-environment --systemd --all'
  hl.exec_cmd 'systemctl --user start hyprland-session.target'
  hl.exec_cmd 'hyprpaper'
  hl.exec_cmd 'hypridle'
  hl.exec_cmd 'qs -c overview'
end)

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
hl.window_rule {
  name = 'suppress-maximize-events',
  match = { class = '.*' },
  suppress_event = 'maximize',
}

hl.window_rule {
  name = 'fix-xwayland-drags',
  match = {
    class = '^$',
    title = '^$',
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
}

hl.window_rule {
  name = 'move-hyprland-run',
  match = { class = 'hyprland-run' },
  move = '20 monitor_h-120',
  float = true,
}
