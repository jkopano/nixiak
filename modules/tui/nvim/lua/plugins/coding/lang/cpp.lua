return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_user_command("CppSyncInterfaceImplementation", function()
        require("util.cpp_interface").toggle()
      end, { desc = "Sync a C++ declaration/definition between interface and implementation" })
    end,
    opts = function(_, opts)
      opts.servers["*"] = opts.servers["*"] or {}
      opts.servers["*"].keys = opts.servers["*"].keys or {}
      opts.servers["*"].keys[#opts.servers["*"].keys + 1] = {
        "<leader>ca",
        function()
          if vim.bo.filetype == "cpp" then
            require("util.cpp_interface").code_action()
          else
            vim.lsp.buf.code_action()
          end
        end,
        desc = "Code Action",
        mode = { "n", "x" },
        has = "codeAction",
      }
      return opts
    end,
  },
}
