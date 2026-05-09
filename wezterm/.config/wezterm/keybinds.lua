local templates = require "templates"

local M = {}

function M.apply(config, wezterm)
  config.keys = {
    {
      key = "t",
      mods = "CMD|SHIFT",
      action = wezterm.action_callback(templates.dev),
    },
    {
      key = "d",
      mods = "CMD",
      action = wezterm.action.SplitHorizontal,
    },
    {
      key = "d",
      mods = "CMD|SHIFT",
      action = wezterm.action.SplitVertical,
    },
    {
      key = "w",
      mods = "CMD",
      action = wezterm.action.CloseCurrentPane { confirm = true },
    },
    {
      key = "f",
      mods = "CTRL|CMD",
      action = wezterm.action.ToggleFullScreen,
    },
    -- pane 移動
    {
      key = "h",
      mods = "CMD|OPT",
      action = wezterm.action.ActivatePaneDirection "Left",
    },
    {
      key = "l",
      mods = "CMD|OPT",
      action = wezterm.action.ActivatePaneDirection "Right",
    },
    {
      key = "k",
      mods = "CMD|OPT",
      action = wezterm.action.ActivatePaneDirection "Up",
    },
    {
      key = "j",
      mods = "CMD|OPT",
      action = wezterm.action.ActivatePaneDirection "Down",
    },
  }
end

return M
