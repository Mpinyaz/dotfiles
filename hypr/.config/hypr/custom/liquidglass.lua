if hl.plugin.hyprliquid then
  hl.plugin.hyprliquid = {
    watch_system_color_scheme = true,
    background_sharing = true,
  }

  hl.window_rule {
    name = 'kitty',
    match = { class = 'kitty' },
    border_size = 0,
    no_blur = true,
    no_shadow = true,
    ['hyprliquid:rounding_lua'] = 64,
    ['hyprliquid:effect'] = 'liquid_glass',
    ['hyprliquid:tint_color'] = 'rgba(0x1a, 0x1b, 0x26, 0.5)',
    ['hyprliquid:highlight_style'] = 2,
    ['hyprliquid:glass_dispersion'] = true,
  }

  hl.window_rule {
    name = 'zen-browser',
    match = { class = 'zen' },
    ['hyprliquid:effect'] = 'acrylic_thin',
    ['hyprliquid:color_scheme'] = 'follow_system',
  }

  hl.window_rule {
    name = 'vscode',
    match = { class = 'code' },
    ['hyprliquid:effect'] = 'acrylic',
    ['hyprliquid:color_scheme'] = 'dark',
  }

  hl.window_rule {
    name = 'dolphin',
    match = { class = 'org.kde.dolphin' },
    ['hyprliquid:effect'] = 'mica_alt',
    ['hyprliquid:color_scheme'] = 'light',
  }

  hl.layer_rule {
    name = 'waybar',
    match = { namespace = 'waybar' },
    ['hyprliquid:effect'] = 'liquid_glass',
    ['hyprliquid:corner_radius'] = 20,
    ['hyprliquid:highlight_style'] = 4,
    ['hyprliquid:vdf_map_mode'] = 1,
    ['hyprliquid:vdf_map_update_policy'] = 'onchange',
  }

  hl.layer_rule {
    name = 'wlogout',
    match = { namespace = 'logout_dialog' },
    blur = true,
    ['hyprliquid:effect'] = 'liquid_glass',
    ['hyprliquid:corner_radius'] = 96,
    ['hyprliquid:highlight_style'] = 4,
    ['hyprliquid:vdf_map_mode'] = 2,
    ['hyprliquid:vdf_map_update_policy'] = 'once',
  }
end
