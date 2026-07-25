local M = {}

function M.apply(config, wezterm)
  config.font = wezterm.font_with_fallback {
    "Cascadia Code NF",
    "PlemolJP Console NF", -- 日本語フォールバック
  }
  config.font_size = 13.0
  config.line_height = 1.3
  config.window_background_opacity = 1
  -- config.macos_window_background_blur = 10
  config.window_decorations = "RESIZE"
  config.window_frame = {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none"
  }
  config.window_background_gradient = {
    colors = { "#000000" }
  }
end

return M
