-- Keymap helper
local map = vim.keymap.set
local opts = { silent = true }

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable space default behavior
map({ "n", "v" }, "<Space>", "<Nop>", opts)

-------------------------------------------------
-- Core
-------------------------------------------------

-- File explorer
map("n", "<leader>pv", "<cmd>Ex<CR>", { desc = "Open netrw" })
map("n", "<leader>e", "<cmd>Neotree<CR>", { desc = "Open Neo-tree" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Save & Quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })

-- Better paste (visual)
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-------------------------------------------------
-- Window Management
-------------------------------------------------

-- Resize
map("n", "<C-Up>", "<cmd>resize -2<CR>", opts)
map("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Splits
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equal splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- Window navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move to upper window" })

-------------------------------------------------
-- Terminal
-------------------------------------------------

map("n", "<leader>t", "<cmd>terminal<CR>", { desc = "Open terminal" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-------------------------------------------------
-- Search Navigation
-------------------------------------------------

map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

-------------------------------------------------
-- Telescope
-------------------------------------------------

map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })

-------------------------------------------------
-- Bufferline
-------------------------------------------------

map("n", "<C-z>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<C-x>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
-- Toggle comment on current line (normal mode)
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })

-- Toggle comment on selected lines (visual mode)
vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })
