local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "Tokyo Night"
config.font = wezterm.font("Agave Nerd Font", { weight = "Bold" })
config.font_size = 30.0
config.window_close_confirmation = "NeverPrompt"
config.default_cursor_style = "BlinkingBar"
return config
