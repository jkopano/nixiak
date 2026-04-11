return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.icons = {
        rules = {
          { pattern = "explorer", icon = LazyVim.config.icons.kinds.File, color = "orange" },
        },
      }
      return opts
    end,
  },
}
