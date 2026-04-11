return {
  "gruvw/strudel.nvim",
  lazy = false,
  build = "npm install",
  keys = {
    { "<leader>ml", mode = "n", "<cmd>StrudelLaunch<cr>", { desc = "Launch Strudel" } },
    { "<leader>mq", mode = "n", "<cmd>StrudelQuit<cr>", { desc = "Quit Strudel" } },
    { "<leader>mt", mode = "n", "<cmd>StrudelToggle<cr>", { desc = "Strudel Toggle Play/Stop" } },
    { "<leader>mu", mode = "n", "<cmd>StrudelUpdate<cr>", { desc = "Update Strudel" } },
    { "<leader>ms", mode = "n", "<cmd>StrudelStop<cr>", { desc = "Strudel Stop Playback" } },
    { "<leader>mx", mode = "n", "<cmd>StrudelExecute<cr>", { desc = "Strudel set current buffer and update" } },
  },
  config = function()
    require("strudel").setup({
      ui = {
        -- hide_menu_panel = true,
        -- hide_top_bar = true,
        -- hide_error_display = true,
        -- hide_code_editor = false,
      },
    })
  end,
}
