local wezterm = require 'wezterm'
local tools = require 'lib.utils'.mytable


config = tools.merge_all(
  require 'cfg_appearance',
  require 'cfg_font',
  require 'cfg_key',
  {}
)
-- Finally, return the configuration to wezterm:
return config
