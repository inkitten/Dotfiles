return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim", -- handles auto-install & auto-enable
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd", -- covers C/C++ (dropped ccls: conflicts with clangd on same filetypes)
					--"jsonls",
					"marksman",
					"rust_analyzer", -- was "rust-analyzer" (wrong name, underscore not hyphen)
					--"ts_ls",
					--"eslint", -- was "vscode-eslint" (wrong name)
					--"hls", -- Haskell (dropped ghcide: old predecessor to hls, don't run both)
					"pyright"
				},
				automatic_enable = true, -- auto vim.lsp.enable() on install/open
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		-- Single spec now — config lives here, no duplicate entry
		config = function()
			-- Load cmp's LSP capabilities so servers know what the completion UI supports
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			if ok_cmp then
				capabilities = cmp_lsp.default_capabilities(capabilities)
			end

			-- Shared on_attach (keymaps, etc.) — defined once, no duplicate opts/keymaps
			local on_attach = function(_, bufnr)
				local opts = { buffer = bufnr, noremap = true, silent = true }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end

			-- Customize servers that need tweaks (others use nvim-lspconfig defaults automatically)
			vim.lsp.config("lua_ls", {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config("pyright", {
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- For clangd, yamlls, jsonls, marksman, bashls, rust_analyzer, ts_ls, eslint, hls →
			-- no custom settings needed. mason-lspconfig's automatic_enable already calls
			-- vim.lsp.enable() for them, but they still need on_attach + capabilities,
			-- so we set defaults for every server that doesn't have a custom vim.lsp.config above.
			vim.lsp.config("*", {
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end,
	},

	-- Completion: VSCode-style popup + Tab to accept
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- LSP source
			"hrsh7th/cmp-buffer", -- buffer words source
			"hrsh7th/cmp-path", -- filesystem path source
			"L3MON4D3/LuaSnip", -- snippet engine
			"saadparwaiz1/cmp_luasnip", -- snippet source for cmp
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter confirms selection

					-- Tab / Shift-Tab: VSCode-style cycle + accept
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},
}
