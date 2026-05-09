return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Diffview Open" },
    { "<leader>gc", "<Cmd>DiffviewClose<CR>", desc = "Diffview Close" },
    { "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", desc = "File History (current)" },
    { "<leader>gH", "<Cmd>DiffviewFileHistory<CR>", desc = "File History (all)" },
  },
  opts = {},
}
