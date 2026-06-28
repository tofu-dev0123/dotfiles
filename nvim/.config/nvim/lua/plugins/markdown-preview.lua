return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  keys = {
    { "<leader>mp", "<Cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Markdown Preview Toggle" },
  },
  build = "cd app && npm install",
  config = function()
    vim.g.mkdp_auto_start = 1
  end,
}
