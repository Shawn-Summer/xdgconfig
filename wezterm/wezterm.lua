local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.automatically_reload_config = true
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
-- font --
config.font =
  wezterm.font('Maple Mono NF CN', { weight = 'Bold' })
config.font_size = 12
-- config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' } -- disable ligature

-- 基础配置
config.window_background_opacity = 0.5
config.macos_window_background_blur = 30

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

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
-- config.window_decorations = "RESIZE"
config.window_frame = {
   inactive_titlebar_bg = "none",
   active_titlebar_bg = "none",
 }
config.colors = {
  tab_bar = {
    background = "none",
    inactive_tab_edge = "none"
  },
}
config.window_background_gradient = {
   colors = { scheme_def.background },
 }

config.window_close_confirmation = "NeverPrompt"


-- Finally, return the configuration to wezterm:
return config
