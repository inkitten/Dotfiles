return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree", -- lazy load when command is used
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree" },
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,

      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },

      window = {
        width = 30,
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "toggle_node",
        },
      },
    })
  end,
}
