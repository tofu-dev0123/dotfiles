return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    providers = { "lsp", "treesitter", "regex" },
    delay = 100,
    under_cursor = true,
    large_file_cutoff = 10000,
    filetypes_denylist = {
      "dirbuf",
      "dirvish",
      "fugitive",
    },
  },
  config = function(_, opts)
    require("illuminate").configure(opts)

    -- 下線ではなく背景色でハイライト（VSCode スタイル）
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#3a3a4a" })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#3a3a4a" })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3a3a4a" })

    vim.keymap.set("n", "]]", function()
      require("illuminate").goto_next_reference(false)
    end, { desc = "次の参照へ" })
    vim.keymap.set("n", "[[", function()
      require("illuminate").goto_prev_reference(false)
    end, { desc = "前の参照へ" })
  end,
}
