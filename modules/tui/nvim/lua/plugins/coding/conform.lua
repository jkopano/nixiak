return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  opts = function(_, opts)
    opts.formatters_by_ft = {
      cs = { "csharpier" },
    }
    opts.formatters = {
      csharpier = {
        command = "~/.dotnet/tools/dotnet-csharpier",
        args = { "--write-stdout" },
      },
    }
  end,
}
