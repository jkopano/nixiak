return {
  "GustavEikaas/easy-dotnet.nvim",
  ft = "cs",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("easy-dotnet").setup()
  end,
  keys = {
    {
      "<leader>D",
      mode = "n",
      ft = "cs",
      "<cmd>Dotnet<cr>",
      desc = "Dotnet",
    },
  },
}
