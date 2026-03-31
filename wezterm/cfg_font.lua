local wezterm = require 'wezterm'
config = {}

-- font --
config.font =
  wezterm.font('Maple Mono NF CN', { weight = 'Bold' })
config.font_size = 12
-- config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' } -- disable ligature

return config
