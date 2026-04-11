return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "folke/snacks.nvim" },
    event = "VeryLazy",
    opts = function()
      local cs = --require("base16-colorscheme").colors or
        require("catppuccin.palettes").get_palette("mocha")

      local colors = {
        bg = cs.base00 or cs.base,
        fg = cs.base05 or cs.text,
        yellow = cs.base0A or cs.yellow,
        cyan = cs.base0C or cs.sapphire,
        darkblue = cs.base07 or cs.lavender,
        green = cs.base0B or cs.green,
        orange = cs.base09 or cs.peach,
        violet = cs.base0E or cs.mauve,
        magenta = cs.base0F or cs.maroon,
        blue = cs.base0D or cs.blue,
        red = cs.base08 or cs.red,
      }

      local mode_color = {
        n = colors.green,
        i = colors.blue,
        v = colors.magenta,
        ["[27;5;118~"] = colors.orange,
        V = colors.magenta,
        c = colors.yellow,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        ["[27;5;115~"] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red,
      }

      local theme = require("lualine.themes.base16")
      theme.normal.c.bg = colors.bg
      theme.normal.c.fg = colors.fg
      theme.inactive.c.bg = colors.bg
      theme.inactive.c.fg = colors.fg

      local opts = {
        options = {
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          theme = theme,
        },
        sections = {
          lualine_a = {
            {
              "mode",
              icons_enabled = true,
              fmt = function(str)
                return str:sub(1, 3)
              end,
              separator = {
                right = "",
              },
            },
          },
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              color = { fg = colors.yellow, gui = "bold" },
              symbols = { modified = " ", readonly = " " },
            },
            {
              "diagnostics",
              padding = { left = 0, right = 0 },
            },
            {
              "location",
              color = { fg = colors.cyan, gui = "bold" },
              padding = { left = 1, right = 1 },
              icon = "",
            },
            {
              "progress",
              color = { fg = colors.cyan, gui = "bold" },
              padding = { left = 0 },
            },
            {
              function()
                return "%="
              end,
            },
          },
          lualine_x = {
            {
              function()
                return "%="
              end,
            },
            Snacks.profiler.status(),
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function()
                return { fg = Snacks.util.color("Special") }
              end,
            },
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = function()
                return { fg = mode_color[vim.fn.mode()] }
              end,
              padding = { right = 1, left = 0 },
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = function()
                return { fg = Snacks.util.color("Constant") }
              end,
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = function()
                return { fg = Snacks.util.color("Debug") }
              end,
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 0, right = 1 } },
            {
              "diff",
              symbols = { added = " ", modified = " ", removed = " " },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
              padding = { left = 0, right = 1 },
            },
            {
              "branch",
              icon = "",
              color = { fg = colors.violet, gui = "bold" },
              padding = { right = 1, left = 0 },
            },
          },
          lualine_y = {},
          lualine_z = {},
        },
        inactive_sections = {},
        extensions = { "lazy", "trouble", "nvim-tree" },
      }
      return opts
    end,
  },
}
