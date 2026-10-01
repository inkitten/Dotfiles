-- Formatting with conform.nvim using system-installed formatters.
-- Missing formatters are skipped (LSP formatting is used as a fallback).
-- Run :ToolsCheck to see what is installed.
return {
	{
		"stevearc/conform.nvim",
		config = function()
			local conform = require("conform")

			-- ruff if available, otherwise black
			local function python(_)
				if vim.fn.executable("ruff") == 1 then
					return { "ruff_organize_imports", "ruff_format" }
				end
				return { "black" }
			end

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = python,
					sh = { "shfmt" },
					bash = { "shfmt" },
					json = { "jq", "prettier", stop_after_first = true },
					jsonc = { "prettier" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					html = { "prettierd", "prettier", stop_after_first = true },
					css = { "prettierd", "prettier", stop_after_first = true },
					yaml = { "prettierd", "prettier", stop_after_first = true },
					markdown = { "prettierd", "prettier", stop_after_first = true },
					toml = { "taplo" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					rust = { "rustfmt" },
					-- haskell: no formatter listed -> falls back to hls formatting
				},

				formatters = {
					shfmt = { prepend_args = { "-i", "4" } }, -- match shiftwidth = 4
				},

				default_format_opts = { lsp_format = "fallback" },

				format_on_save = function(bufnr)
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					return { timeout_ms = 2000, lsp_format = "fallback" }
				end,
			})

			-- Manual format (was <leader>f, which collided with <leader>ff/fg/fb/fh)
			vim.keymap.set({ "n", "v" }, "<leader>cf", function()
				conform.format({ async = true })
			end, { desc = "Format buffer / selection" })

			-- Toggle format-on-save (global, or buffer-only with !)
			vim.api.nvim_create_user_command("FormatToggle", function(args)
				if args.bang then
					vim.b.disable_autoformat = not vim.b.disable_autoformat
					vim.notify("Format on save (this buffer): " .. (vim.b.disable_autoformat and "OFF" or "ON"))
				else
					vim.g.disable_autoformat = not vim.g.disable_autoformat
					vim.notify("Format on save (global): " .. (vim.g.disable_autoformat and "OFF" or "ON"))
				end
			end, { bang = true, desc = "Toggle format on save (! = current buffer only)" })

			vim.keymap.set("n", "<leader>uf", "<cmd>FormatToggle<CR>", { desc = "Toggle format on save" })
			vim.keymap.set("n", "<leader>uF", "<cmd>FormatToggle!<CR>", { desc = "Toggle format on save (buffer)" })
		end,
	},
}
