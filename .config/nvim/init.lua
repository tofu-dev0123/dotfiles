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
   {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
        },
      })
     end,
   },

   {
     "williamboman/mason.nvim",
     config = function()
       require("mason").setup()
     end,
   },
   {
     "williamboman/mason-lspconfig.nvim",
     dependencies = { "williamboman/mason.nvim" },
     config = function()
       require("mason-lspconfig").setup({
         ensure_installed = {
           "pyright",
           "ts_ls",   -- ← tsserverの新名称
           "lua_ls",
         },
       })
     end,
   },

   {
     "neovim/nvim-lspconfig",
     config = function()

       -- Python
       vim.lsp.config("pyright", {})
       vim.lsp.enable("pyright")

       -- TypeScript / JavaScript
       vim.lsp.config("ts_ls", {})
       vim.lsp.enable("ts_ls")

       -- Lua
       vim.lsp.config("lua_ls", {
         settings = {
           Lua = {
             diagnostics = {
               globals = { "vim" },
             },
           },
         },
       })
       vim.lsp.enable("lua_ls")
     end,
   },
})

vim.opt.termguicolors = true

-- クリップボードとの連携
vim.opt.clipboard = "unnamedplus"

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


-- keymap --
vim.keymap.set("i", "jk", "<Esc>")
