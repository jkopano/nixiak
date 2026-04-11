return {
  {
    "folke/persistence.nvim",
    enabled = false,
    event = "BufReadPre",
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end,              desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
  },
  {
    "jkopano/sip.nvim",
    enabled = true,
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>qs",
        function()
          require("sip").select()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>ql",
        function()
          require("sip").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>qL",
        function()
          require("sip").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("sip").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
}
