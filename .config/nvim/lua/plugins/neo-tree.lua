return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
  },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
        },
        window = {
          mappings = {
            ["<leader>yp"] = function(state)
              local node = state.tree:get_node()
              local path = node.path
              local cwd = vim.loop.cwd()
              local rel = path:gsub(cwd .. "/", "")
              vim.fn.setreg("+", rel)
              print("Copied: " .. rel)
            end,
            ["<leader>yP"] = function(state)
              local node = state.tree:get_node()
              vim.fn.setreg("+", node.path)
              print("Copied: " .. node.path)
            end,
          },
        },
      },
      window = {
        position = "left",
        width = 32,
      },
    })
  end,
}
