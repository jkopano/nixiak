-- Options are automatically loaded before lazy.nvim startup
-- Default optsions that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/optsions.lua
-- Add any additional optsions here

vim.g.snacks_animate = false
vim.opt.relativenumber = true
-- vim.opt.cursorline = false
vim.opt.cursorlineopt = "number"
vim.opt.spelllang = { "pl", "en" }
vim.filetype.add({
  extension = {
    typst = "typst", -- Set the filetype for .typst files
    -- pde = "processing",
  },
})
