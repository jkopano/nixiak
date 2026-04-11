return {
  "marcinjahn/gemini-cli.nvim",
  cmd = "Gemini",
  enabled = false,
  -- Example key mappings for common actions:
  keys = {
    { "<leader>an", "<cmd>Gemini toggle<cr>",   desc = "Toggle Gemini CLI" },
    { "<leader>aa", "<cmd>Gemini ask<cr>",      desc = "Ask Gemini",       mode = { "n", "v" } },
    { "<leader>ab", "<cmd>Gemini add_file<cr>", desc = "Add File" },
  },
  dependencies = {
    "folke/snacks.nvim",
  },
  opts = function(_, opts)
    opts.win = {
      position = "bottom",
    }
  end,
  config = true,
}
