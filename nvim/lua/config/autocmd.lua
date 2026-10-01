-- Autocommands
local api = vim.api

-- Plugins are not on the runtimepath yet at this point, so never let a missing
-- colorscheme abort init.lua; fall back to tokyonight once plugins are loaded.
if not pcall(vim.cmd.colorscheme, "catppuccin") then
	api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			local c = vim.g.colors_name
			if not c or c == "default" then
				pcall(vim.cmd.colorscheme, "tokyonight")
			end
		end,
	})
end

-- Create a general augroup helper
local function augroup(name)
	return api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- Toggle comment on current line (normal mode)
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })

-- Toggle comment on selected lines (visual mode)
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })
-------------------------------------------------
-- Highlight on Yank
-------------------------------------------------

api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank({ timeout = 150 })
	end,
})

-------------------------------------------------
-- Restore cursor position
-------------------------------------------------

api.nvim_create_autocmd("BufReadPost", {
	desc = "Restore last cursor position",
	group = augroup("restore_cursor"),
	callback = function()
		local mark = api.nvim_buf_get_mark(0, '"')
		local line_count = api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-------------------------------------------------
-- Auto create parent directories on save
-------------------------------------------------

api.nvim_create_autocmd("BufWritePre", {
	desc = "Auto create missing directories",
	group = augroup("auto_create_dir"),
	callback = function(event)
		local file = vim.loop.fs_realpath(event.match) or event.match
		local dir = vim.fn.fnamemodify(file, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-------------------------------------------------
-- Remove trailing whitespace on save
-------------------------------------------------

api.nvim_create_autocmd("BufWritePre", {
	desc = "Trim trailing whitespace",
	group = augroup("trim_whitespace"),
	callback = function()
		local save = api.nvim_win_get_cursor(0)
		vim.cmd([[%s/\s\+$//e]])
		api.nvim_win_set_cursor(0, save)
	end,
})

-------------------------------------------------
-- Auto reload file if changed outside nvim
-------------------------------------------------

api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	desc = "Auto reload changed files",
	group = augroup("auto_reload"),
	command = "checktime",
})

-------------------------------------------------
-- Close certain filetypes with q
-------------------------------------------------

api.nvim_create_autocmd("FileType", {
	desc = "Close with q",
	group = augroup("close_with_q"),
	pattern = {
		"help",
		"man",
		"lspinfo",
		"qf",
		"checkhealth",
		"git",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<CR>", {
			buffer = event.buf,
			silent = true,
		})
	end,
})

-------------------------------------------------
-- Briefly highlight current line after yank movement
-------------------------------------------------

api.nvim_create_autocmd("CursorHold", {
	desc = "Light cursorline on idle",
	group = augroup("cursorline_idle"),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

api.nvim_create_autocmd("CursorMoved", {
	group = augroup("cursorline_idle"),
	callback = function()
		vim.opt_local.cursorline = false
	end,
})
