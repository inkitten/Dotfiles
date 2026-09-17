-- Options helper
local opt = vim.opt

-- Nerd font flag (used by some configs/plugins)
vim.g.have_nerd_font = true

-------------------------------------------------
-- UI
-------------------------------------------------

opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.showmode = false
opt.mouse = "a"
opt.confirm = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.autoindent = true
opt.breakindent = true

-- Clipboard
opt.clipboard = "unnamedplus"

-------------------------------------------------
-- Search
-------------------------------------------------

opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-------------------------------------------------
-- Scrolling & Timing
-------------------------------------------------

opt.scrolloff = 9
opt.updatetime = 250
opt.timeoutlen = 350

-------------------------------------------------
-- Splits
-------------------------------------------------

opt.splitright = true
opt.splitbelow = true

-------------------------------------------------
-- Undo
-------------------------------------------------

opt.undofile = true

-------------------------------------------------
-- Invisible Characters
-------------------------------------------------
