return {
  {
    "AckslD/swenv.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>cv",
        function()
          require("swenv.api").pick_venv()
        end,
        desc = "Pick virtual environment",
      },
    },
    opts = {
      get_venvs = function(venvs_path)
        return require("swenv.api").get_venvs(venvs_path)
      end,
      venvs_path = vim.fn.expand("~/.venvs"),
      post_set_venv = function()
        vim.cmd("LspRestart")
      end,
    },
  },
}
