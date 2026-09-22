return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
      return opts
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = function(_, opts)
      opts.automatic_installation = true
      -- opts.ensure_installed = {}
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.automatic_enable = false
      opts.ensure_installed = {}

      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- local keys = require("lazyvim.plugins.lsp.keymaps").get()
      opts.inlay_hints = { enabled = false }

      -- opts.servers.ruff = {}
      opts.servers.zls = {
        mason = false,
        settings = {
          zls = {
            build_on_save_args = { "-fincremental" },
            semantic_tokens = "partial",
          },
        },
      }
      opts.servers.clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders=true",
          "--fallback-style=llvm",
          "--j=8",
          "--pch-storage=disk",
        },
        init_options = {
          fallbackFlags = { "-std=c++26" },
        },
      }

      opts.servers.ruff.cmd = { "uv", "run", "ruff", "server" }
      opts.servers.pyright.cmd = { "uv", "run", "pyright-langserver", "--stdio" }
      opts.setup = {
        ["ruff"] = function()
          Snacks.util.lsp.on({ name = "ruff" }, function(_, client)
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end)
        end,
      }

      local servers_to_off_mason = {
        "bashls",
        "tinymist",
        "fish_lsp",
        "clangd",
        "jdtls",
        "nil_ls",
        "zls",
        "ruff",
        "fsautocomplete",
        "tailwindcss",
        "omnisharp",
        "jsonls",
        "shfmt",
        "taplo",
        "marksman",
        "pyright",
        "ruff",
        "gdscript",
        "lua_ls",
        "stylua",
        "fennel_ls",
        "glsl_analyzer",
        "gleam",
        "gdshader_lsp",
        "typst_lsp",
        "hls",
        "nixd",
        "neocmakelsp",
        "gopls",
      }

      for _, lsp in ipairs(servers_to_off_mason) do
        opts.servers[lsp] = opts.servers[lsp] or {}
        opts.servers[lsp].mason = false
      end

      return opts
    end,
  },
}
