return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	event = "VeryLazy",

	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				separator_style = "slant",
				always_show_bufferline = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
				margin = 2,

				indicator = {
					style = "icon",
					icon = "▇",
				},
			},

			highlights = {
				background = {
					fg = "#5f5f5f",
					bg = "#1c1c1c",
				},

				buffer_selected = {
					fg = "#ff5f5f", -- lava red text
					bg = "#1a0f0f", -- dark volcanic
					bold = true,
				},

				buffer_visible = {
					fg = "#a8a87f",
					bg = "#1f1f1a",
				},

				separator = {
					fg = "#1c1c1c",
					bg = "#1c1c1c",
				},

				separator_selected = {
					fg = "#1a0f0f",
					bg = "#1a0f0f",
				},
				indicator_selected = {
					fg = "#ff0000",
					bg = "#1a0f0f",
				},
				modified_selected = {
					fg = "#ff0000",
					bg = "#1a0f0f",
				},
			},
		})

		vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { silent = true })
		vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { silent = true })
		vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { silent = true })
		vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { silent = true })
	end,
}
