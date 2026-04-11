return {
  "Maxteabag/sqlit.nvim",
  opts = {},
  keys = {
    {
      "<leader>D",
      function()
        require("sqlit").open()
      end,
      desc = "Database (sqlit)",
    },
  },
}
