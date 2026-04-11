return {
  -- {
  --   "3rd/image.nvim",
  --   config = function()
  --     require("image").setup({
  --       backend = "ueberzug",
  --       integrations = {
  --         markdown = {
  --           enabled = true,
  --           clear_in_insert_mode = true,
  --           download_remote_images = true,
  --           only_render_image_at_cursor = false,
  --           filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
  --         },
  --       },
  --       kitty_method = "normal",
  --       max_width = 100,
  --       max_height = nil,
  --       max_width_window_percentage = nil,
  --       max_height_window_percentage = 50,
  --       window_overlap_clear_enabled = false,
  --       window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  --       editor_only_render_when_focused = false,
  --       tmux_show_only_in_active_window = false,
  --       hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  --     })
  --   end,
  -- },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      { "<leader>gb", "<cmd>Gitsigns blame<CR>", desc = "Blame" },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "gh" } },
    keys = {
      {
        "<leader>gG",
        function()
          Snacks.terminal({ "gh", "dash" })
        end,
        desc = "Git dash (cwd)",
      },
    },
  },
}
