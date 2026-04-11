return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    opts = function(_, opts)
      opts.lightbulb = { sign = false, virtual_text = false }
      opts.implement = { enable = false }

      opts.symbol_in_winbar = { folder_level = 2 }

      return opts
    end,

    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons",     -- optional
    },
  },
}
