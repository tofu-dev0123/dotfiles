return {
  -- デフォルト
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    priority = 1000,
    lazy = false,
  },

  -- 切替候補
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = { flavour = "mocha" },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = { theme = "wave" },
  },
  {
    "sainnhe/everforest",
    lazy = true,
    init = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_better_performance = 1
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = { variant = "auto", dark_variant = "main" },
  },
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    init = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = true,
  },
}
