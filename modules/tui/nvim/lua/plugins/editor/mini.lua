return {
  {
    "nvim-mini/mini.splitjoin",
    keys = "gS",
    config = function()
      require("mini.splitjoin").setup()
    end,
  },
  {
    "nvim-mini/mini.bracketed",
    lazy = false,
    config = function()
      require("mini.bracketed").setup({
        buffer = { suffix = "", options = {} },
        comment = { suffix = "", options = {} },
        conflict = { suffix = "", options = {} },
        diagnostic = { suffix = "", options = {} },
        file = { suffix = "x", options = {} },
        indent = { suffix = "", options = {} },
        jump = { suffix = "", options = {} },
        location = { suffix = "", options = {} },
        oldfile = { suffix = "", options = {} },
        quickfix = { suffix = "", options = {} },
        treesitter = { suffix = "", options = {} },
        undo = { suffix = "", options = {} },
        window = { suffix = "", options = {} },
        yank = { suffix = "", options = {} },
      })
    end,
  },
}
