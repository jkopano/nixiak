return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = {
      -- search = false,
      highlight = {
        backdrop = true,
      },
      modes = {
        char = {
          highlight = {
            backdrop = false,
          },
          jump_labels = false,
        },
      },
      char_actions = false,
    },
    -- stylua: ignore
    keys = {
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash"
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search"
      },
      { "S", mode = { "n", "x", "o" }, false },
      { "s", mode = { "n", "v", "x" }, false }
    },
  },
}
