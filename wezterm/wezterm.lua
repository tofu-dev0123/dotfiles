local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.use_ime = true

require("appearance").apply(config, wezterm)
require("tabs").apply(config, wezterm)
require("keybinds").apply(config, wezterm)

return config
