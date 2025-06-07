local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.color_scheme = "Argonaut"
config.font = wezterm.font_with_fallback({
	{
		family = "Agave Nerd Font",
		weight = "Bold",
		harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
	},
	{ family = "Terminus", weight = "Bold" },
	"Noto Color Emoji",
})
config.window_frame = {
	-- Berkeley Mono for me again, though an idea could be to try a
	-- serif font here instead of monospace for a nicer look?
	font = wezterm.font({ family = "Agave Nerd Font", weight = "Bold" }),
	font_size = 20,
}
config.font_size = 25.0
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.7,
}
config.window_close_confirmation = "NeverPrompt"
config.default_cursor_style = "BlinkingBar"
config.window_background_gradient = {
	orientation = "Vertical",

	colors = {
		"#0f0c29",
		"#302b63",
		"#24243e",
	},

	interpolation = "Linear",

	blend = "Rgb",
}
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
wezterm.on("update-status", function(window)
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	local color_scheme = window:effective_config().resolved_palette
	local bg = color_scheme.background
	local fg = color_scheme.foreground

	window:set_right_status(wezterm.format({
		{ Background = { Color = "none" } },
		{ Foreground = { Color = bg } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = bg } },
		{ Foreground = { Color = fg } },
		{ Text = " " .. wezterm.hostname() .. " " },
	}))
end)
return config
