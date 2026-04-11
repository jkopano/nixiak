return {
  {
    "numToStr/Navigator.nvim",
    keys = {
      { "<c-h>", "<cmd>NavigatorLeft<cr>" },
      { "<c-j>", "<cmd>NavigatorDown<cr>" },
      { "<c-k>", "<cmd>NavigatorUp<cr>" },
      { "<c-l>", "<cmd>NavigatorRight<cr>" },
    },
    opts = function()
      require("Navigator").setup()
      --   -- vim.keymap.set({ "n", "t" }, "<C-k>", "<CMD>NavigatorUp<CR>")
      --   -- vim.keymap.set({ "n", "t" }, "<A-l>", "<CMD>NavigatorRight<CR>")
      --   -- vim.keymap.set({ "n", "t" }, "<A-k>", "<CMD>NavigatorUp<CR>")
      --   -- vim.keymap.set({ "n", "t" }, "<A-j>", "<CMD>NavigatorDown<CR>")
      --   -- vim.keymap.set({ "n", "t" }, "<A-p>", "<CMD>NavigatorPrevious<CR>")
    end,
    lazy = false,
  },
}
