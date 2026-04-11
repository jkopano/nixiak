return {
  "S1M0N38/love2d.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "<leader>v",  ft = { "lua", "fennel" }, desc = "LÖVE" },
    { "<leader>vv", "<cmd>LoveRun<cr>",       ft = { "lua", "fennel" }, desc = "Run LÖVE" },
    { "<leader>vs", "<cmd>LoveStop<cr>",      ft = { "lua", "fennel" }, desc = "Stop LÖVE" },
  },
}
