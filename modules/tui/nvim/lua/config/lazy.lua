-- stylua: ignore
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local extras = "lazyvim.plugins.extras."

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = extras .. "ai.codeium" },
    { import = extras .. "ai.avante" },
    { import = extras .. "coding.blink" },
    { import = extras .. "coding.neogen" },
    { import = extras .. "coding.luasnip" },
    { import = extras .. "dap.core" },
    { import = extras .. "dap.nlua" },
    { import = extras .. "editor.illuminate" },
    { import = extras .. "editor.overseer" },
    { import = extras .. "editor.dial" },
    { import = extras .. "editor.fzf" },
    { import = extras .. "editor.inc-rename" },
    { import = extras .. "editor.navic" },
    { import = extras .. "formatting.prettier" },
    { import = extras .. "ui.treesitter-context" },
    { import = extras .. "lang.clangd" },
    { import = extras .. "lang.rust" },
    { import = extras .. "lang.git" },
    { import = extras .. "lang.java" },
    { import = extras .. "lang.dotnet" },
    -- { import = extras .. "lang.scala" },
    { import = extras .. "lang.json" },
    { import = extras .. "lang.markdown" },
    { import = extras .. "lang.tailwind" },
    { import = extras .. "lang.toml" },
    { import = extras .. "lang.nix" },
    { import = extras .. "lang.haskell" },
    { import = extras .. "lang.gleam" },
    { import = extras .. "lang.typst" },
    { import = extras .. "lang.zig" },
    { import = extras .. "lang.cmake" },
    { import = extras .. "lang.go" },
    -- { import = extras .. "lang.sql" },
    -- { import = extras .. "lsp.none-ls" },
    { import = extras .. "util.dot" },
    { import = extras .. "util.octo" },
    { import = extras .. "util.mini-hipatterns" },
    { import = extras .. "test.core" },
    { import = extras .. "lsp.neoconf" },
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = true, -- notify on update
  },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
