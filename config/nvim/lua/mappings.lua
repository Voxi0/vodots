-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Alias
map = vim.keymap.set

-- Toggle line numbers
map("n", "<leader>n", "<cmd>set number!<cr>", { desc = "Toggle line numbers" })
map("n", "<leader>rn", "<cmd>set relativenumber!<cr>", { desc = "Toggle relative line numbers" })

-- Delete without yanking/copying
map({ "n", "v" }, "d", '"_d', { desc = "Delete" })

-- Clear search highlights
map("n", "<escape>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- Better indenting in visual mode
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Convenience
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- LSP
-- Toggle virtual text for diagnostics
map("n", "<leader>lx", function()
  local state = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not state })
end, { desc = "Toggle LSP virtual text" })

-- Format
map("n", "<leader>mp", vim.lsp.buf.format, { desc = "Format buffer using LSP" })

-- Buffers
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Goto next buffer" })
map("n", "<leader>bp", "<cmd>bprev<cr>", { desc = "Goto previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete current buffer" })

-- Window splits
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Create vertical split" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Create horizontal split" })
map("n", "<C-k>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-h>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<C-l>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })

-- Misc
-- Move a whole line or selection up or down
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
