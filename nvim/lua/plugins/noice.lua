return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({
			cmdline = {
				enabled = true,
				view = "cmdline_popup", -- makes it floating
			},

			views = {
				cmdline_popup = {
					position = {
						row = "40%",
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
					border = {
						style = "rounded",
					},
				},
			},

			messages = {
				enabled = true,
			},

			popupmenu = {
				enabled = true,
			},
		})
	end,
}
