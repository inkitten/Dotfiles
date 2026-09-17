return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    -- Middle-earth palette
    local colors = {
      bg     = "#1c1c1c",   -- deep cavern
      fg     = "#a8a87f",   -- parchment
      yellow = "#d7af5f",   -- dwarven gold
      green  = "#5f875f",   -- moss
      orange = "#af875f",   -- ember
      red    = "#875f5f",   -- dark wine
      brown  = "#2a2a1f",   -- earth
    }

    local theme = {
      normal = {
        a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
        b = { fg = colors.fg, bg = colors.brown },
        c = { fg = colors.fg, bg = colors.bg },
      },

      insert = {
        a = { fg = colors.bg, bg = colors.green, gui = "bold" },
      },

      visual = {
        a = { fg = colors.bg, bg = colors.orange, gui = "bold" },
      },

      replace = {
        a = { fg = colors.bg, bg = colors.red, gui = "bold" },
      },

      inactive = {
        a = { fg = colors.fg, bg = colors.bg },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
    }

    require("lualine").setup({
      options = {
        theme = theme,
        section_separators = { left = "", right = "" },
        component_separators = { left = "│", right = "│" },
        globalstatus = true,
      },

      sections = {
        lualine_a = {
          { "mode", icon = "󰮯" }, -- nerd icon
        },

        lualine_b = {
          { "branch", icon = "" },
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
        },

        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = " ●",
              readonly = " ",
            },
          },
        },

        lualine_x = {
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn  = " ",
              info  = " ",
              hint  = "󰌵 ",
            },
          },
          "encoding",
          "filetype",
        },

        lualine_y = {
          { "progress", icon = "" },
        },

        lualine_z = {
          { "location", icon = "󰍉" },
        },
      },
    })
  end,
}
