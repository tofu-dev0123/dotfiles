local M = {}

function M.apply(config, wezterm)
	config.hide_tab_bar_if_only_one_tab = true
	config.show_new_tab_button_in_tab_bar = false

	config.colors = {
		tab_bar = {
			inactive_tab_edge = "none",
		},
	}

	local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
	local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

	wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
		local background = "#5c6d74"
		local foreground = "#FFFFFF"
		local edge_background = "none"

		if tab.is_active then
			background = "#47763c"
			foreground = "#FFFFFF"
		end
		local edge_foreground = background

		local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

		return {
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = background } },
			{ Foreground = { Color = foreground } },
			{ Text = title },
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	end)
end

return M
