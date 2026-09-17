-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	}
},
  -- automatically check for plugin updates
  checker = { enabled = false },
})
