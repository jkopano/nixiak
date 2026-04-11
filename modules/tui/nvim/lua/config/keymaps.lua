-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local del = vim.keymap.del

-- map("n", "<leader>q", "<cmd>q!<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit All" })
map("n", "<leader>ww", "<cmd>update<cr>", { desc = "Write" })
map("n", "<leader>wa", "<cmd>wall<cr>", { desc = "Write" })
-- map({ "n", "t" }, "<C-t>", function()
--   Snacks.terminal.toggle("sh -c zsh", {})
-- end, { desc = "terminal" })
map({ "i", "c" }, "<A-h>", "<Left>")
map({ "i", "c" }, "<A-j>", "<Down>")
map({ "i", "c" }, "<A-k>", "<Up>")
map({ "i", "c" }, "<A-l>", "<Right>")
map({ "n", "v" }, "J", "%")
-- del(n, "<leader>w")
map("n", "<C-f>", "20jzz")
map("n", "<C-b>", "20kzz")
map("n", "<C-d>", "12jzz")
map("n", "<C-u>", "12kzz")
map("n", "<BS>", "<C-6>")

del("n", "<leader>l")
map("n", "<leader>\\", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- del(n, "gd")
-- del(n, "gr")
