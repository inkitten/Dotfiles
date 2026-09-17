-- lua/plugins/alpha.lua     (or wherever you put plugin specs)
return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VimEnter", -- lazy-load on startup screen
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- ── Middle-earth inspired color palette ───────────────────────────────
			local colors = {
				gold = "#d4af37",
				darkgreen = "#1a3c34",
				forest = "#2f6a4f",
				mithril = "#a8b5b2",
				shadow = "#1e2a2f",
				parchment = "#f5e8c7",
				rune_grey = "#5c6370",
			}

			-- ── Custom header (Tolkien / Middle-earth banner style) ───────────────
			dashboard.section.header.val = {
				"                                                       ",
				"                ▄▄▄▄    ▄▄▄       ██▓     ██▓        ",
				"               ▓█████▄ ▒████▄    ▓██▒    ▓██▒        ",
				"               ▒██▒ ▄██▒██  ▀█▄  ▒██░    ▒██░        ",
				"               ▒██░█▀  ░██▄▄▄▄██ ▒██░    ▒██░        ",
				"               ▓█  ▀█▓ ▓█   ▓██▒░██████▒░██████▒     ",
				"               ▒█▓▒█▀  ▒▒   ▓▒█░░ ▒░▓  ░░ ▒░▓  ░     ",
				"               ▒█▒▒▒   ▒▒   ▒▒ ░░ ░ ▒  ░░ ░ ▒  ░     ",
				"               ░ ░▒    ░    ▒     ░ ░     ░ ░        ",
				"                   ░    ░  ░ ░       ░  ░    ░  ░    ",
				"                                                       ",
				"               ~ Welcome to Middle-earth ~             ",
				"           One does not simply walk into Mordor...     ",
				"                                                       ",
			}

			dashboard.section.header.opts.hl = "String"

			-- ── Buttons with LOTR flavor ──────────────────────────────────────────
			dashboard.section.buttons.val = {
				dashboard.button("e", "  New file (like opening the Red Book)", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f", "󰈞  Find file (Scry the lands of Arda)", ":Telescope find_files <CR>"),
				dashboard.button("r", "  Recent files (Tales already told)", ":Telescope oldfiles <CR>"),
				dashboard.button("p", "  Projects (Realms to rule)", ":Telescope projects<CR>"),
				dashboard.button("c", "  Config (Forge your own mithril)", ":e $MYVIMRC <CR>"),
				dashboard.button("u", "  Update plugins (Seek the wisdom of the Valar)", ":Lazy sync<CR>"),
				dashboard.button("q", "  Quit (Fade into the West)", ":qa<CR>"),
			}

			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "Function"
				button.opts.hl_shortcut = "Type"
			end

			-- ── Footer with random Tolkien-ish quote ──────────────────────────────
			local quotes = {
				"Not all those who wander are lost.",
				"All we have to decide is what to do with the time that is given us.",
				"Even the smallest person can change the course of the future.",
				"There is some good in this world, and it’s worth fighting for.",
				"The world is changed. I feel it in the water. I feel it in the earth.",
				"My heart is with the sea, and I will look on the sea no more.",
				"I will not say: do not weep; for not all tears are an evil.",
			}

			local function pick_random_quote()
				math.randomseed(os.time())
				return quotes[math.random(1, #quotes)]
			end

			dashboard.section.footer.val = {
				" ",
				pick_random_quote(),
				" ",
			}

			dashboard.section.footer.opts.hl = "Comment"

			-- ── Overall layout tweaks ─────────────────────────────────────────────
			dashboard.opts.layout = {
				{ type = "padding", val = 2 },
				dashboard.section.header,
				{ type = "padding", val = 2 },
				dashboard.section.buttons,
				{ type = "padding", val = 2 },
				dashboard.section.footer,
			}

			dashboard.opts.opts.noautocmd = true

			-- Apply config
			alpha.setup(dashboard.opts)

			-- Disable folding in alpha buffer
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "alpha",
				callback = function()
					vim.opt_local.foldenable = false
					vim.opt_local.colorcolumn = "0"
				end,
			})

			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					vim.api.nvim_set_hl(0, "AlphaHeader", { fg = colors.gold })
					vim.api.nvim_set_hl(0, "AlphaButtons", { fg = colors.forest })
					vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = colors.mithril, bold = true })
					vim.api.nvim_set_hl(0, "AlphaFooter", { fg = colors.rune_grey, italic = true })
				end,
			})

			-- Trigger once on startup
			vim.api.nvim_exec_autocmds("ColorScheme", {})
		end,
	},
}
