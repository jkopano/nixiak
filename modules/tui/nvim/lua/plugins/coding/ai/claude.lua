return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    enabled = true,
    config = true,
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>an", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>ac", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    },
    opts = function(_, opts)
      opts.terminal = {
        split_side = "left",
        snacks_win_opts = {
          position = "bottom",
          height = 0.4,
          width = 1.0,
          border = "rounded",
          title = " Claude ",
          title_pos = "center",
        },
      }
    end,
  },
  {
    "pittcat/claude-fzf.nvim",
    dependencies = {
      "ibhagwan/fzf-lua",
      "coder/claudecode.nvim",
    },
    opts = {
      auto_context = true,
      batch_size = 10,
    },
    cmd = {
      "ClaudeFzf",
      "ClaudeFzfFiles",
      "ClaudeFzfGrep",
      "ClaudeFzfBuffers",
      "ClaudeFzfGitFiles",
      "ClaudeFzfDirectory",
    },
    keys = {
      { "<leader>af", "<cmd>ClaudeFzfFiles<cr>",     desc = "Claude: Add files" },
      { "<leader>ag", "<cmd>ClaudeFzfGrep<cr>",      desc = "Claude: Search and add" },
      { "<leader>cB", "<cmd>ClaudeFzfBuffers<cr>",   desc = "Claude: Add buffers" },
      { "<leader>aG", "<cmd>ClaudeFzfGitFiles<cr>",  desc = "Claude: Add Git files" },
      { "<leader>ad", "<cmd>ClaudeFzfDirectory<cr>", desc = "Claude: Add directory files" },
    },
  },
}
