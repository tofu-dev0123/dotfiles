return {
  "FotiadisM/tabset.nvim",
  config = function()
    require("tabset").setup({
      defaults = {
        tabwidth = 2,
        expandtab = true,
      },
      languages = {
        go = {
          tabwidth = 4,
          expandtab = false,
        },
        python = {
          tabwidth = 4,
          expandtab = true,
        },
        javascript = {
          tabwidth = 2,
          expandtab = true,
        },
        lua = {
          tabwidth = 2,
          expandtab = true,
        },
        make = {
          tabwidth = 4,
          expandtab = false,
        },
        typescript = {
          tabwidth = 2,
          expandtab = true,
        },
        luau = {
          tabwidth = 2,
          expandtab = true,
        },
        terraform = {
          tabwidth = 2,
          expandtab = true,
        },
      },
    })
  end,
}
