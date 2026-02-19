return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  main = "nvim-treesitter.config",
  opts = {
    ensure_installed = {
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      "json",
      "terraform",
      "hcl",
    },
    highlight = { enable = true },
    indent = { enable = true },
  },
}
