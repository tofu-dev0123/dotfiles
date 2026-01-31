-- leader key
vim.g.mapleader = " "

vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

require("lazy").setup({

  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          section_separators = "",
          component_separators = "",
        },
      })
    end,
  },
  {
     "nvim-neo-tree/neo-tree.nvim",
     branch = "v3.x",
     dependencies = {
       "nvim-lua/plenary.nvim",
       "nvim-tree/nvim-web-devicons",
       "MunifTanjim/nui.nvim",
     },
     config = function()
       require("neo-tree").setup({
         filesystem = {
           filtered_items = {
             hide_dotfiles = false,
           },
         },
         window = {
           position = "left",
           width = 32,
         },
       })

       vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
     end,
   },

   {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.config",
    opts = {
      highlight = { enable = true },
    },
  },
})

vim.opt.termguicolors = true

-- 行番号を表示
vim.opt.number = true
vim.opt.relativenumber = true

-- カーソル行を強調
vim.opt.cursorline = true

-- 折り返しをわかりやすく表示
vim.opt.wrap = false

-- スクロール余白
vim.opt.scrolloff = 8

vim.cmd.colorscheme("catppuccin-mocha")

vim.cmd [[
	highlight Normal guibg=none
	highlight NormalFloat guibg=none
]]
