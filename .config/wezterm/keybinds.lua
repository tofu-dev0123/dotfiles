local M = {}

function M.apply(config, wezterm)
	config.keys = {
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
		}
	}
end

return M
