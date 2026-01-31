local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true

require("appearance").apply(config)
require("tabs").apply(config, wezterm)
require("keybinds").apply(config, wezterm)

return config
