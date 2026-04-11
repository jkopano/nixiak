return {
  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    keys = {
      {
        "e",
        function()
          require("spider").motion("e")
        end,
        mode = { "n", "o", "x" },
        desc = "Spider-e",
      },
      {
        "b",
        function()
          require("spider").motion("b")
        end,
        mode = { "n", "o", "x" },
        desc = "Spider-b",
      },
      {
        "w",
        function()
          require("spider").motion("w")
        end,
        mode = { "n", "o", "x" },
        desc = "Spider-w",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    keys = {
      {
        "s",
        "<PLug>(nvim-surround-visual)",
        mode = { "x" },
        desc = "Add a surrounding pair",
      },
    },
    opts = {
      skipInsignificantPunctuation = false,
    },
  },
}
