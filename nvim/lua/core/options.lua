local opt = vim.opt

opt.termguicolors = true

-- クリップボードとの連携
opt.clipboard = "unnamedplus"

-- 行番号を表示
opt.number = true
opt.relativenumber = true

-- カーソル行を強調
opt.cursorline = true

-- 折り返しをわかりやすく表示
opt.wrap = false

-- スクロール余白
opt.scrolloff = 8

-- 外部で変更されたら自動で検知
opt.autoread = true

-- カーソル移動・フォーカス復帰時に変更チェック
vim.api.nvim_create_autocmd(
  { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
  {
    command = "checktime",
  }
)
