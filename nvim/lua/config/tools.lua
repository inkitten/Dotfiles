-- Central list of external tools (LSP servers, formatters, tree-sitter parsers).
-- Everything is expected to come from the system package manager (pacman / AUR),
-- so nothing has to be downloaded by Mason.
--
--   bin = executable looked up in $PATH
--   pkg = Manjaro package that provides it
--   aur = true when the package lives in the AUR

local M = {}

M.servers = {
	lua_ls = { bin = "lua-language-server", pkg = "lua-language-server" },
	clangd = { bin = "clangd", pkg = "clang" },
	rust_analyzer = { bin = "rust-analyzer", pkg = "rust-analyzer" },
	pyright = { bin = "pyright-langserver", pkg = "pyright" },
	marksman = { bin = "marksman", pkg = "marksman-bin", aur = true },
	bashls = { bin = "bash-language-server", pkg = "bash-language-server" },
	ts_ls = { bin = "typescript-language-server", pkg = "typescript-language-server" },
	jsonls = { bin = "vscode-json-language-server", pkg = "vscode-langservers-extracted" },
	html = { bin = "vscode-html-language-server", pkg = "vscode-langservers-extracted" },
	cssls = { bin = "vscode-css-language-server", pkg = "vscode-langservers-extracted" },
	yamlls = { bin = "yaml-language-server", pkg = "yaml-language-server" },
	taplo = { bin = "taplo", pkg = "taplo-cli" },
	hls = { bin = "haskell-language-server-wrapper", pkg = "haskell-language-server" },
}

M.formatters = {
	stylua = { bin = "stylua", pkg = "stylua" },
	ruff = { bin = "ruff", pkg = "ruff" }, -- ruff OR black is enough for Python
	black = { bin = "black", pkg = "python-black" },
	shfmt = { bin = "shfmt", pkg = "shfmt" },
	prettier = { bin = "prettier", pkg = "prettier" },
	jq = { bin = "jq", pkg = "jq" },
	["clang-format"] = { bin = "clang-format", pkg = "clang" },
	rustfmt = { bin = "rustfmt", pkg = "rust" }, -- or `rustup component add rustfmt`
	taplo = { bin = "taplo", pkg = "taplo-cli" },
}

M.parsers = {
	"rust", "javascript", "python", "bash", "c", "cpp", "lua",
	"luadoc", "vim", "vimdoc", "markdown", "haskell",
}

function M.exe(bin)
	return vim.fn.executable(bin) == 1
end

function M.has_parser(lang)
	return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) > 0
end

--- Show a report of which tools are available and how to install the rest.
function M.check()
	local lines = { "Tools check  (q to close)", "" }
	local pacman, aur = {}, {}

	local function add_missing(t)
		local list = t.aur and aur or pacman
		if not vim.tbl_contains(list, t.pkg) then
			table.insert(list, t.pkg)
		end
	end

	local function section(title, tbl)
		lines[#lines + 1] = title
		local names = vim.tbl_keys(tbl)
		table.sort(names)
		for _, name in ipairs(names) do
			local t = tbl[name]
			local ok = M.exe(t.bin)
			lines[#lines + 1] = string.format("  [%s] %-16s %s", ok and "ok" or "--", name, t.bin)
			if not ok then
				add_missing(t)
			end
		end
		lines[#lines + 1] = ""
	end

	section("LSP servers", M.servers)
	section("Formatters", M.formatters)

	lines[#lines + 1] = "Tree-sitter parsers"
	local missing_parsers = {}
	for _, lang in ipairs(M.parsers) do
		local ok = M.has_parser(lang)
		lines[#lines + 1] = string.format("  [%s] %s", ok and "ok" or "--", lang)
		if not ok then
			table.insert(missing_parsers, lang)
		end
	end
	lines[#lines + 1] = ""

	if #pacman > 0 then
		lines[#lines + 1] = "Install missing (pacman):"
		lines[#lines + 1] = "  sudo pacman -S --needed " .. table.concat(pacman, " ")
		lines[#lines + 1] = ""
	end
	if #aur > 0 then
		lines[#lines + 1] = "Install missing (AUR):"
		lines[#lines + 1] = "  yay -S " .. table.concat(aur, " ")
		lines[#lines + 1] = ""
	end
	if #missing_parsers > 0 then
		lines[#lines + 1] = "Missing parsers: try `pacman -Ss tree-sitter-<lang>`, or"
		lines[#lines + 1] = "  :TSInstall " .. table.concat(missing_parsers, " ")
		lines[#lines + 1] = "  (needs the tree-sitter-cli package + access to GitHub)"
		lines[#lines + 1] = ""
	end
	lines[#lines + 1] = "Not every '--' is a problem: only install what you actually use."

	vim.cmd("botright new")
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = "toolscheck"
	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
end

vim.api.nvim_create_user_command("ToolsCheck", M.check, {
	desc = "Show which LSP servers / formatters / parsers are installed",
})

return M
