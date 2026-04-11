return {
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      local dap = require("dap")

      dap.adapters.godot = {
        type = "server",
        host = "127.0.0.1",
        port = 6006,
      }

      dap.adapters["local-lua"] = {
        type = "executable",
        command = "node",
        args = {
          "/home/kuba/.local/share/nvim/mason/share/local-lua-debugger-vscode/extension/debugAdapter.js"
        },
        enrich_config = function(config, on_config)
          if not config["extensionPath"] then
            local c = vim.deepcopy(config)
            -- 💀 If this is missing or wrong you'll see
            -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
            c.extensionPath = "/home/kuba/.local/share/nvim/mason/share/local-lua-debugger-vscode/"
            on_config(c)
          else
            on_config(config)
          end
        end,
      }

      dap.configurations.lua = {
        {
          type = "local-lua",
          request = "launch",
          name = "Launch LÖVE",
          program = "${file}",
          runtimeExecutable = "love",             -- Assumes 'love' is in your PATH
          runtimeArgs = { "${workspaceFolder}" }, -- Runs the project directory
          console = "integratedTerminal",
        },
      }

      dap.configurations.gdscript = {
        {
          type = "godot",
          request = "launch",
          name = "Launch scene",
          scene = "current",
          project = "${workspaceFolder}",
        },
      }

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dap.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dap.close()
      end

      return opts
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        -- dapui.close({})
      end
    end,
  },
}
