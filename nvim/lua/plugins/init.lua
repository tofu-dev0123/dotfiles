local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins.diffview" },
  { import = "plugins.barbar" },
  { import = "plugins.toggleterm" },
  { import = "plugins.alpha" },
  { import = "plugins.markdown-preview" },
  { import = "plugins.colorscheme" },
  { import = "plugins.lualine" },
  { import = "plugins.neo-tree" },
  { import = "plugins.treesitter" },
  { import = "plugins.cmp" },
  { import = "plugins.lsp" },
  { import = "plugins.tabset" },
  { import = "plugins.telescope" },
}, {
  checker = { enabled = false },
  change_detection = { notify = false },
})
