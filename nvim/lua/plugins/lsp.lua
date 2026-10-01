-- LSP using ONLY system-installed servers (pacman / AUR). No Mason.
-- A server is enabled only when its executable exists, so a missing package
-- never produces errors. Run :ToolsCheck to see what is installed / missing.
return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local tools = require("config.tools")

			---------------------------------------------------------------
			-- Diagnostics look & behaviour
			---------------------------------------------------------------
			local sev = vim.diagnostic.severity
			vim.diagnostic.config({
				severity_sort = true,
				update_in_insert = false,
				underline = true,
				virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
				float = { border = "rounded", source = true },
				signs = {
					text = {
						[sev.ERROR] = vim.fn.nr2char(0xf057),
						[sev.WARN] = vim.fn.nr2char(0xf071),
						[sev.INFO] = vim.fn.nr2char(0xf05a),
						[sev.HINT] = vim.fn.nr2char(0xf0335),
					},
				},
			})

			---------------------------------------------------------------
			-- Capabilities (nvim-cmp) for every server
			---------------------------------------------------------------
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
			if ok_cmp then
				capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
			end
			vim.lsp.config("*", { capabilities = capabilities })

			---------------------------------------------------------------
			-- Per-server tweaks (everything else uses nvim-lspconfig defaults)
			---------------------------------------------------------------
			local overrides = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = {
								checkThirdParty = false,
								library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
							},
							completion = { callSnippet = "Replace" },
							hint = { enable = true },
							telemetry = { enable = false },
						},
					},
				},
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
					},
					capabilities = { offsetEncoding = { "utf-16" } },
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
								diagnosticMode = "openFilesOnly",
							},
						},
					},
				},
			}

			for name, info in pairs(tools.servers) do
				vim.lsp.config(name, overrides[name] or {})
				if tools.exe(info.bin) then
					vim.lsp.enable(name)
				end
			end

			---------------------------------------------------------------
			-- Keymaps & per-buffer features (run when a server attaches)
			---------------------------------------------------------------
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("custom_lsp_attach", { clear = true }),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = "LSP: " .. desc })
					end

					map("n", "gd", vim.lsp.buf.definition, "Go to definition")
					map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
					map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
					map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
					map("n", "gr", vim.lsp.buf.references, "References")
					map("n", "K", function()
						vim.lsp.buf.hover({ border = "rounded" })
					end, "Hover docs")
					map("i", "<C-s>", vim.lsp.buf.signature_help, "Signature help")
					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
					map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

					-- <leader>e is Neo-tree, so line diagnostics live on <leader>d
					map("n", "<leader>d", vim.diagnostic.open_float, "Line diagnostics")
					map("n", "[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, "Previous diagnostic")
					map("n", "]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, "Next diagnostic")
					map("n", "<leader>dl", vim.diagnostic.setloclist, "Diagnostics to location list")

					map("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", "Document symbols")
					map("n", "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace symbols")

					if client and client:supports_method("textDocument/inlayHint", ev.buf) then
						map("n", "<leader>uh", function()
							local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
							vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
						end, "Toggle inlay hints")
					end

					-- Highlight other uses of the symbol under the cursor
					if client and client:supports_method("textDocument/documentHighlight", ev.buf) then
						local hl = vim.api.nvim_create_augroup("custom_lsp_highlight_" .. ev.buf, { clear = true })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							group = hl,
							buffer = ev.buf,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							group = hl,
							buffer = ev.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("custom_lsp_detach", { clear = true }),
				callback = function(ev)
					pcall(vim.api.nvim_del_augroup_by_name, "custom_lsp_highlight_" .. ev.buf)
					vim.lsp.buf.clear_references()
				end,
			})
		end,
	},
}
