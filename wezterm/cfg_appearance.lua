local wezterm = require 'wezterm'
config = {}
config.initial_cols = 120
config.initial_rows = 40
-- theme --
function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end
local scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.color_scheme = scheme
local scheme_def = wezterm.color.get_builtin_schemes()[scheme]

-- background --
config.window_background_opacity = 0.5
config.macos_window_background_blur = 30

config.window_background_gradient = { -- 让 tab 和 background 一致
   colors = { scheme_def.background },
 }

-- 核心：监听窗口状态变化，自动切换透明度
wezterm.on('window-resized', function(window, pane)
  local is_full_screen = window:get_dimensions().is_full_screen
  if is_full_screen then
    window:set_config_overrides({
      window_background_opacity = 1
    })
  else
    window:set_config_overrides({
      window_background_opacity = config.window_background_opacity
    })
  end
end)

-- tabs --
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.colors = {
  tab_bar = {
    background = "none",
    inactive_tab_edge = "none"
  },
}

-- titlebar --
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
-- config.window_decorations = "RESIZE"
config.window_frame = {
   inactive_titlebar_bg = "none",
   active_titlebar_bg = "none",
 }

return config
