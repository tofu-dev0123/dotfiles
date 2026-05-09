return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<C-\\>", desc = "Toggle terminal" },
    { "<leader>tf", desc = "Toggle float terminal" },
    { "<leader>th", desc = "Toggle horizontal terminal"},
    { "<leader>tv", desc = "Toggle vertical terminal"},
    { "<leader>gg", desc = "Toggle lazygit" },
  },
  config = function()
    require("toggleterm").setup({
      -- size --
      size = function(term)
	if term.direction == "vertical" then
	  return vim.o.columns * 0.4
	elseif term.direction == "horizontal" then
	  return 15
	end
      end,

      -- toggle key mapping --
      open_mapping = [[<C-\>]],

      -- terminal settings --
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,

      -- ターミナルを閉じた時にプロセス終了 --
      close_on_exit = true,
    })

    -- 追加のキーマッピング --
    local Terminal = require("toggleterm.terminal").Terminal

    -- 垂直ターミナル --
    local vertical_term = Terminal:new({ direction = "vertical" })
    vim.keymap.set("n", "<leader>tv", function()
    vertical_term:toggle() end, { desc = "Toggle vertical terminal" })

    -- 水平ターミナル
     local horizontal_term = Terminal:new({ direction = "horizontal" })
     vim.keymap.set("n", "<leader>th", function()
     horizontal_term:toggle() end, { desc = "Togglehorizontal terminal" })

    -- lazygitターミナル--
    local lazygit = Terminal:new({
      cmd = "lazygit",
      hidden = true,
      direction = "float",
      float_opts = {
        border = "curved",
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        -- q で lazygit だけ閉じる
        vim.keymap.set("t", "q", function()
          term:toggle()
        end, { buffer = term.bufnr })
      end,
    })

    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end

    vim.keymap.set("n", "<leader>gg", _LAZYGIT_TOGGLE)

  end,
}
