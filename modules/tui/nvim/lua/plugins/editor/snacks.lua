return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    statuscolumn = { enabled = true },
    zen = {
      toggles = {
        dim = false,
        git_signs = false,
        mini_diff_signs = true,
        -- diagnostics = false,
        -- inlay_hints = false,
      },
    },
  },
}
