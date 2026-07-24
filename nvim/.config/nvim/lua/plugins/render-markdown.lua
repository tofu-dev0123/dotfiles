return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- 見出し: アイコン付き・フル幅背景・下線で階層を明確化
    heading = {
      sign = true,
      width = "full",
      border = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    -- コードブロック: 枠付きボックス + 言語ラベルで HTML の <pre> 風に
    code = {
      sign = true,
      style = "full",
      width = "block",
      border = "thick",
      left_pad = 2,
      right_pad = 2,
      language_pad = 2,
    },
    -- 箇条書き: 階層ごとに記号を変える
    bullet = {
      icons = { "●", "○", "◆", "◇" },
    },
    -- チェックボックス
    checkbox = {
      checked = { icon = "󰱒 " },
      unchecked = { icon = "󰄱 " },
    },
    -- テーブル: 角丸罫線でレンダリング表示に寄せる
    pipe_table = {
      preset = "round",
    },
  },
}
