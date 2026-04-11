return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    keys = {
      {
        "<leader>e",
        function()
          require("nvim-tree.api").tree.toggle()
        end,
        desc = "Explorer Tree (Root Dir)",
      },
    },
    opts = function()
      -- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ecbe7b" })
      -- vim.api.nvim_set_hl(0, "TabLineFill", { fg = "#dfdfdf", bg = "#1f2329" })
      -- vim.api.nvim_set_hl(0, "TabLine", { fg = "#dfdfdf", bg = "#1f2329" })
      -- -- vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#51afef", bg = "#dfdfdf" })
      --
      -- vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#1f2329" })
      -- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#131313" })
      -- vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "#51afef", fg = "#51afef" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ecbe7b" })
      vim.api.nvim_set_hl(0, "TabLineFill", { fg = "#dfdfdf", bg = "#1d2021" })
      vim.api.nvim_set_hl(0, "TabLine", { fg = "#dfdfdf", bg = "#1d2021" })
      -- vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#51afef", bg = "#dfdfdf" })

      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#282828" })
      vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#1b1b1b" })
      vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "#5b534d", fg = "#51afef" })
      local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function keybinding(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        local mappings = {
          ["h"] = { api.tree.change_root_to_parent, "Up" },
          ["l"] = { api.node.open.edit, "Open" },
          ["v"] = { api.node.open.vertical, "Open Verically" },
          ["s"] = { api.node.open.horizontal, "Open horizontally" },
          ["K"] = { api.node.navigate.sibling.next, "Next sibling" },
          ["J"] = { api.node.navigate.sibling.prev, "Prev sibling" },
          ["D"] = { api.fs.remove, "Delete" },
          ["?"] = { api.tree.toggle_help, "Help" },
        }
        for keys, mapping in pairs(mappings) do
          vim.keymap.set("n", keys, mapping[1], keybinding(mapping[2]))
        end
      end

      return {
        on_attach = my_on_attach,
        auto_reload_on_write = true,
        hijack_cursor = true,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = true,
        root_dirs = {},
        prefer_startup_root = false,
        sync_root_with_cwd = false,
        reload_on_bufenter = true,
        respect_buf_cwd = false,
        -- remove_keymaps = false,
        select_prompts = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        view = {
          width = 35,
          side = "right",
          preserve_window_proportions = true,
          signcolumn = "yes",
          centralize_selection = true,
          adaptive_size = false,
          float = {
            enable = false,
            quit_on_focus_loss = false,
            open_win_config = function()
              return {
                row = 0,
                width = 38,
                border = "rounded",
                relative = "editor",
                col = vim.o.columns,
                height = vim.o.lines - 3,
              }
            end,
          },
        },
        renderer = {
          add_trailing = false,
          highlight_git = "name",
          -- full_name = true,
          highlight_opened_files = "icon",
          hidden_display = "simple",
          root_folder_label = ":t",
          indent_width = 1,
          group_empty = true,
          icons = {
            padding = " ",
            symlink_arrow = " ➛ ",
          },
        },
        filters = {
          dotfiles = true,
          custom = {
            ".*.gd.uid",
          },
        },
        diagnostics = {
          enable = true,
          show_on_dirs = false,
          show_on_open_dirs = true,
          debounce_delay = 50,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
        },
        git = {
          enable = true,
          timeout = 200,
        },
        actions = {
          use_system_clipboard = true,
          change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
          },
          expand_all = {
            max_folder_discovery = 300,
            exclude = {},
          },
          open_file = {
            quit_on_open = false,
            window_picker = {
              enable = true,
              chars = "ASDFGHJKL",
            },
          },
          remove_file = {
            close_window = true,
          },
        },
      }
    end,
  },
}
