return {
  {
    "jakewvincent/mkdnflow.nvim",
    opts = function()
      return {
        modules = {
          cmp = true,
        },
        mappings = {
          MkdnUpdateNumbering = { "n", "<leader>nu" },
          MkdnEnter = { { "i", "n", "v" }, "<CR>" }, -- This monolithic command has the aforementioned
          MkdnGoForward = { "n", "<S-BS>" },
          MkdnDestroyLink = { "n", "<M-CR>" },
          MkdnIncreaseHeading = { "n", "K" },
          MkdnDecreaseHeading = { "n", "J" },
          -- insert-mode-specific behavior and also will trigger row jumping in tables. Outside
          -- of lists and tables, it behaves as <CR> normally does.
          -- MkdnNewListItem = {'i', '<CR>'} -- Use this command instead if you only want <CR> in
          -- insert mode to add a new list item (and behave as usual outside of lists).
        },
        tables = {
          trim_whitespace = true,
          format_on_move = true,
          auto_extend_rows = true,
          auto_extend_cols = false,
        },
        new_file_template = {
          use_template = true,
          placeholders = {
            before = {
              title = "link_title",
              date = function()
                return os.date("%B %d, %Y") -- Wednesday, March 1, 2023
              end,
            },
            after = {},
          },
          template = [[
# {{ title }}   *{{date}}*


@JK
]],
        },
        to_do = {
          symbols = { " ", "⧖", "✓" },
          update_parents = true,
          not_started = " ",
          in_progress = "⧖",
          complete = "✓",
        },
        links = {
          style = "markdown",
          name_is_source = true,
          conceal = false,
          context = 0,
          implicit_extension = nil,
          transform_implicit = false,
          transform_explicit = function(text)
            text = text:gsub(" ", "-")
            text = text:lower()
            text = text .. os.date("_%m-%d")
            return text
          end,
        },
      }
    end,
    ft = { "markdown" },
  },
  {
    "HakonHarnes/img-clip.nvim",
    cmd = "PasteImage",
    opts = { default = { relative_to_current_file = true } },
    keys = {
      -- suggested keymap
      { "<leader>P", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
    },
  },
  {
    "jannis-baum/vivify.vim",
    keys = {
      { "<leader>um", "<cmd>Vivify<cr>", desc = "Preview markdown" },
    },
    ft = { "markdown" },
  },
  {
    "hedyhli/markdown-toc.nvim",
    ft = "mardown", -- Lazy load on markdown filetype
    cmd = { "Mtoc" }, -- Or, lazy load on "Mtoc" command
    opts = {
      -- Your configuration here (optional)
    },
  },
}
