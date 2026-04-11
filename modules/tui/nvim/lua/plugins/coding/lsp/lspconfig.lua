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
      local function mason_off(O)
        O = O or {}
        O.mason = false
        return O
      end

      opts.inlay_hints = { enabled = false }
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
        opts.servers[lsp] = mason_off()
      end

      -- opts.servers.ruff = {}
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

      return opts
    end,
  },
}
