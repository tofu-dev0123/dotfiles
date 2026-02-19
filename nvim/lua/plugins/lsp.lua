return {
  -- Mason
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  -- Mason-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "ts_ls",
          "lua_ls",
          "terraformls",
        },
      })
    end,
  },
  -- LSPconfig
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Python
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.enable("pyright")

      -- TypeScript / JavaScript
      vim.lsp.config("ts_ls", { capabilities = capabilities })
      vim.lsp.enable("ts_ls")

      -- Lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      -- Terraform
      vim.lsp.config("terraformls", { capabilities = capabilities })
      vim.lsp.enable("terraformls")
    end,
  },
}
