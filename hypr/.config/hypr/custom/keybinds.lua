local mainMod = 'SUPER'
local subMod = 'SUPER + SHIFT'
local terminal = 'ghostty'
local fileManager = 'thunar'
local dms = 'dms ipc call '

-- === Basic Actions ===
hl.bind(mainMod .. ' + Q', hl.dsp.window.close())
hl.bind(mainMod .. ' + SHIFT + Q', hl.dsp.exec_cmd "hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill") -- Quit active window and all open instances
-- Exit Logic
hl.bind(mainMod .. ' + M', hl.dsp.exec_cmd 'command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit')
hl.bind('SUPER + E', hl.dsp.exec_cmd(fileManager))

-- Fullscreen: 0 = Fullscreen, 1 = Maximize (Keep gaps/bars)
hl.bind(mainMod .. ' + F', hl.dsp.window.fullscreen { mode = 0 })
hl.bind(subMod .. ' + F', hl.dsp.window.fullscreen { mode = 1 })
hl.bind(mainMod .. ' + S', hl.dsp.workspace.toggle_special 'magic')
hl.bind(mainMod .. ' + P', hl.dsp.window.pseudo())
hl.bind('SUPER + P', hl.dsp.window.pin())
hl.bind(mainMod .. ' + mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true })
-- === Browsers & Tools ===
hl.bind(mainMod .. ' + B', hl.dsp.exec_cmd 'google-chrome-stable')
hl.bind(subMod .. ' + B', hl.dsp.exec_cmd 'firefox')
hl.bind('SUPER + Return', hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. ' + V', hl.dsp.exec_cmd 'pavucontrol')
hl.bind(mainMod .. ' + M', hl.dsp.exec_cmd "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
-- === DMS IPC Controls ===
hl.bind(mainMod .. ' + Space', hl.dsp.exec_cmd(dms .. 'spotlight toggle'))
hl.bind('SUPER + SHIFT + V', hl.dsp.exec_cmd(dms .. 'clipboard toggle'))
hl.bind(mainMod .. ' + comma', hl.dsp.exec_cmd(dms .. 'settings focusOrToggle'))
hl.bind('SUPER + SHIFT + N', hl.dsp.exec_cmd(dms .. 'notifications toggle'))
hl.bind(mainMod .. ' + N', hl.dsp.exec_cmd(dms .. 'notepad toggle'))
hl.bind(mainMod .. ' + X', hl.dsp.exec_cmd(dms .. 'powermenu toggle'))
hl.bind(mainMod .. ' + W', hl.dsp.exec_cmd 'qs ipc -c overview call overview toggle')
hl.bind('SUPER + SHIFT + D', hl.dsp.exec_cmd(dms .. 'processlist focusOrToggle'))

-- -- Tab behavior
hl.bind('SUPER + CTRL + Tab', function()
  hl.dispatch(hl.dsp.window.cycle_next())
  hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Cycle to the next workspace using Super+Shift+Tab
-- hl.bind('SUPER SHIFT + TAB', hl.dsp.workspace.focus_relative(1), { desc = 'Cycle Workspace' })
hl.bind(mainMod .. ' + Tab', hl.dsp.focus { workspace = 'e+1' })
hl.bind(subMod .. ' + Tab', hl.dsp.focus { workspace = 'e-1' })
-- === Relative Workspace Navigation ===
local nav_keys = { 'Right', 'Left' }
for i, key in ipairs(nav_keys) do
  local dir = (i == 1 and '+1' or '-1')
  -- Relative to current monitor
  hl.bind('CTRL + SUPER + ' .. key, hl.dsp.focus { workspace = 'r' .. dir })
  -- Relative to all monitors
  hl.bind('CTRL + SUPER + ALT + ' .. key, hl.dsp.focus { workspace = 'm' .. dir })
end

hl.bind(mainMod .. ' + Page_Down', hl.dsp.focus { workspace = 'r+1' })
hl.bind(mainMod .. ' + Page_Up', hl.dsp.focus { workspace = 'r-1' })

-- === Special Workspace (Scratchpad) ===
hl.bind('SUPER + S', hl.dsp.workspace.toggle_special { name = 'special' })

-- === Navigation & Window Movement ===
local directions = {
  left = 'l',
  down = 'd',
  up = 'u',
  right = 'r',
  H = 'l',
  J = 'd',
  K = 'u',
  L = 'r',
}

for key, dir in pairs(directions) do
  -- Focus
  -- hl.bind(mainMod .. ' + ' .. key, hl.dsp.window.focus { direction = dir })
  -- Move window
  hl.bind(subMod .. ' + ' .. key, hl.dsp.window.move { direction = dir })
  -- Move to Monitor
  hl.bind('SUPER + CTRL + SHIFT + ' .. key, hl.dsp.window.move { monitor = dir })
end

local arrow_keys = {
  left = 'l',
  right = 'r',
  up = 'u',
  down = 'd',
}

for key, dir in pairs(arrow_keys) do
  -- Capitalize key name for correct keybind syntax (e.g., "Left", "Right")
  local capitalizedKey = key:gsub('^%l', string.upper)

  -- Focus window with SUPER + Arrow
  -- hl.bind(mainMod .. ' + ' .. capitalizedKey, hl.dsp.focus { direction = dir })

  -- Optional: Move window with SUPER + SHIFT + Arrow
  hl.bind(subMod .. ' + ' .. capitalizedKey, hl.dsp.window.move { direction = dir })
end
-- === Workspaces (1-10) ===
for i = 1, 10 do
  local ws = i == 10 and 0 or i
  hl.bind(mainMod .. ' + ' .. ws, hl.dsp.focus { workspace = i })
  hl.bind(subMod .. ' + ' .. ws, hl.dsp.window.move { workspace = i })
end

-- === Media & Brightness (bindel for repeat support) ===
hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd(dms .. 'audio increment 3'))
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd(dms .. 'audio decrement 3'))
hl.bind('XF86AudioMute', hl.dsp.exec_cmd(dms .. 'audio mute'))
hl.bind('XF86MonBrightnessUp', hl.dsp.exec_cmd 'brightnessctl -e4 -n2 set 5%+', { locked = true, repeating = true })
hl.bind('XF86MonBrightnessDown', hl.dsp.exec_cmd 'brightnessctl -e4 -n2 set 5%-', { locked = true, repeating = true })

-- === System & Floating ===
hl.bind(mainMod .. ' + Print', hl.dsp.exec_cmd 'dms screenshot full')
hl.bind('SUPER + SHIFT + T', hl.dsp.window.float { action = 'toggle' })

hl.bind(mainMod .. ' + left', hl.dsp.focus { direction = 'left' }) -- Move focus left
hl.bind(mainMod .. ' + right', hl.dsp.focus { direction = 'right' }) -- Move focus right
hl.bind(mainMod .. ' + up', hl.dsp.focus { direction = 'up' }) -- Move focus up
hl.bind(mainMod .. ' + down', hl.dsp.focus { direction = 'down' }) -- Move focus down
