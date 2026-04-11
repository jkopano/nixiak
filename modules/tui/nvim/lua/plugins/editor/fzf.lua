return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  enabled = true,
  keys = {
    {
      "<leader>,",
      "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },
    { "<leader>/",       LazyVim.pick("live_grep"),                        desc = "Grep (Root Dir)" },
    { "<leader>:",       "<cmd>FzfLua command_history<cr>",                desc = "Command History" },
    { "<leader><space>", LazyVim.pick("files", { root = false }),          desc = "Find Files (cwd)" },
    -- find
    { "<leader>fg",      "<cmd>FzfLua git_files<cr>",                      desc = "Find Files (git-files)" },
    { "<leader>fr",      "<cmd>FzfLua oldfiles<cr>",                       desc = "Recent" },
    { "<leader>fR",      LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
    -- git
    { "<leader>gc",      "<cmd>FzfLua git_commits<CR>",                    desc = "Commits" },
    { "<leader>gs",      "<cmd>FzfLua git_status<CR>",                     desc = "Status" },
    -- search
    { '<leader>s"',      "<cmd>FzfLua registers<cr>",                      desc = "Registers" },
    { "<leader>sa",      "<cmd>FzfLua autocmds<cr>",                       desc = "Auto Commands" },
    { "<leader>sb",      "<cmd>FzfLua grep_curbuf<cr>",                    desc = "Buffer" },
    { "<leader>sc",      "<cmd>FzfLua command_history<cr>",                desc = "Command History" },
    { "<leader>sC",      "<cmd>FzfLua commands<cr>",                       desc = "Commands" },
    { "<leader>sd",      "<cmd>FzfLua diagnostics_document<cr>",           desc = "Document Diagnostics" },
    { "<leader>sD",      "<cmd>FzfLua diagnostics_workspace<cr>",          desc = "Workspace Diagnostics" },
    -- changed g with G
    { "<leader>sg",      LazyVim.pick("live_grep", { root = false }),      desc = "Grep (cwd)" },
    { "<leader>sG",      LazyVim.pick("live_grep"),                        desc = "Grep (Root Dir)" },
    { "<leader>sW",      LazyVim.pick("grep_cword"),                       desc = "Word (Root Dir)" },
    { "<leader>sw",      LazyVim.pick("grep_cword", { root = false }),     desc = "Word (cwd)" },
    --
    { "<leader>sh",      "<cmd>FzfLua help_tags<cr>",                      desc = "Help Pages" },
    { "<leader>sH",      "<cmd>FzfLua highlights<cr>",                     desc = "Search Highlight Groups" },
    { "<leader>sj",      "<cmd>FzfLua jumps<cr>",                          desc = "Jumplist" },
    { "<leader>sk",      "<cmd>FzfLua keymaps<cr>",                        desc = "Key Maps" },
    { "<leader>sl",      "<cmd>FzfLua loclist<cr>",                        desc = "Location List" },
    { "<leader>sM",      "<cmd>FzfLua man_pages<cr>",                      desc = "Man Pages" },
    { "<leader>sm",      "<cmd>FzfLua marks<cr>",                          desc = "Jump to Mark" },
    { "<leader>sR",      "<cmd>FzfLua resume<cr>",                         desc = "Resume" },
    { "<leader>sq",      "<cmd>FzfLua quickfix<cr>",                       desc = "Quickfix List" },
    {
      "<leader>sw",
      LazyVim.pick("grep_visual"),
      mode = "v",
      desc = "Selection (Root Dir)",
    },
    {
      "<leader>sW",
      LazyVim.pick("grep_visual", { root = false }),
      mode = "v",
      desc = "Selection (cwd)",
    },
    { "<leader>uC", LazyVim.pick("colorschemes"), desc = "Colorscheme with Preview" },
  },
  opts = function(_, opts)
    local fzf = require("fzf-lua")
    local actions = fzf.actions

    opts[1] = { "fzf-tmux" }

    opts.fzf_colors = {}
    opts.previewers.bat = {
      cmd = "bat",
      args = "--color=always --style=numbers,changes",
    }
    opts.files = {
      fd_opts = [[--color=never --hidden --type f --type l --exclude .git -E "*.uid"]],
      cwd_prompt = false,
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
    }

    opts.git = {
      status = {
        actions = {
          ["right"] = false,
          ["left"] = false,
          ["ctrl-x"] = { fn = actions.git_reset, reload = true },
          ["ctrl-h"] = { fn = actions.git_stage_unstage, reload = true },
        },
      },
    }

    opts.grep = {
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
    }

    opts.fzf_opts = {
      ["--tmux"] = "center,80%,80%",
    }
    opts.lsp = {
      symbols = {
        symbol_hl = function(s)
          return "TroubleIcon" .. s
        end,
        symbol_fmt = function(s)
          return s:lower() .. "\t"
        end,
        child_prefix = false,
      },
      code_actions = {
        previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
      },
    }

    opts.winopts = {
      preview = {
        default = "bat",
        border = "rounded", -- function(_, m)
        --   assert(m.type == "fzf")
        --   -- if FzfLua.utils.has(m.opts, "fzf", { 0, 63 }) then
        --   return "border-line"
        --   -- else
        --   -- return "border-sharp"
        --   -- end
        -- end,
      },
    }

    opts.ui_select = function(fzf_opts, items)
      return vim.tbl_deep_extend("force", fzf_opts, {
        prompt = " ",
        winopts = {
          title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
          title_pos = "center",
        },
      }, fzf_opts.kind == "codeaction" and {
        fzf_opts = {
          ["--gutter"] = " ",
          ["--border"] = "rounded",
          ["--border-label-pos"] = "4",
          -- ["--tmux"] = "center,55%,65%",
        },
        winopts = {
          layout = "vertical",
          height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 4) + 0.5) + 16,
          width = 0.2,
          preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
            layout = "vertical",
            vertical = "down:15,border-top",
            hidden = "hidden",
          } or {
            layout = "vertical",
            vertical = "down:15,border-top",
          },
        },
      } or {
        -- winopts = {
        --   width = 0.5,
        --   height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
        -- },
      })
    end
    return opts
  end,
}
