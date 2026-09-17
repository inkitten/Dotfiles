return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black", "ruff", "djlint" },
					-- haskell = { "ormolu", "fourmolu" },
					sh = { "shfmt", "beautysh" },
					json = { "jq" },
					javascript = { "prettier", "esline" },
					markdown = { "prettier" },
					cpp = { "clang_format" },
					rust = { "rustfm" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
}
