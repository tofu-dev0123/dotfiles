local M = {}

-- ログインシェル経由でコマンドを起動する（PATH をユーザー環境のものにするため）
local function login_shell_args(cmd)
	return { "/bin/zsh", "-lc", "exec " .. cmd }
end

-- 開発用テンプレート: 左上 nvim / 左下 shell / 右 claude
function M.dev(window)
	local mux = window:mux_window()
	local _, left_top, _ = mux:spawn_tab { args = login_shell_args "nvim" }
	left_top:split { direction = "Right", size = 0.4, args = login_shell_args "claude" }
	left_top:split { direction = "Bottom", size = 0.3 }
end

return M
