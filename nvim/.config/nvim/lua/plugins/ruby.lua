return {
  -- Rails開発支援（gf でpartial/route/helperにジャンプ、:A で対応ファイルへ）
  { "tpope/vim-rails" },

  -- Rubyのdef/do/if などに自動でendを補完
  { "tpope/vim-endwise" },

  -- RSpec テスト実行
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>tn", "<cmd>TestNearest<CR>", desc = "Run nearest test" },
      { "<leader>tf", "<cmd>TestFile<CR>",    desc = "Run test file" },
      { "<leader>ta", "<cmd>TestSuite<CR>",   desc = "Run test suite" },
    },
    config = function()
      vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"
      vim.g["test#strategy"] = "toggleterm"
    end,
  },
}
