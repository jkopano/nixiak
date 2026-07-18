return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      local helpers = require("null-ls.helpers")
      local methods = require("null-ls.methods")
      local clang_tidy_checks = table.concat({
        "-*",
        "bugprone-use-after-move",
        -- "bugprone-unchecked-optional-access",
        -- "modernize-macro-to-enum",
        -- "cppcoreguidelines-macro-to-enum",
        -- "misc-include-cleaner",
      }, ",")
      local allowed_clang_tidy_checks = {
        ["bugprone-use-after-move"] = true,
        ["bugprone-unchecked-optional-access"] = true,
        ["modernize-macro-to-enum"] = true,
        ["cppcoreguidelines-macro-to-enum"] = true,
        ["misc-include-cleaner"] = true,
      }
      local parse_clang_tidy = helpers.diagnostics.from_pattern(
        [=[^([^:]+):(%d+):(%d+):%s+([^:]+):%s+(.*)%s+%[([^%]]+)%]$]=],
        { "filename", "row", "col", "severity", "message", "code" },
        {
          severities = {
            ["error"] = helpers.diagnostics.severities.error,
            ["fatal error"] = helpers.diagnostics.severities.error,
            ["warning"] = helpers.diagnostics.severities.warning,
            ["note"] = helpers.diagnostics.severities.information,
          },
        }
      )
      local clang_tidy = helpers.make_builtin({
        name = "clang_tidy",
        method = methods.internal.DIAGNOSTICS_ON_SAVE,
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        generator_opts = {
          command = "clang-tidy",
          args = {
            "$FILENAME",
            -- "--quiet",
            "-checks=" .. clang_tidy_checks,
            "--header-filter=^$",
            "--",
            "-std=c++23",
          },
          to_stdin = false,
          from_stderr = true,
          format = "line",
          check_exit_code = function(code)
            return code <= 1
          end,
          on_output = function(line, params)
            local diagnostic = parse_clang_tidy(line, params)
            if diagnostic and allowed_clang_tidy_checks[diagnostic.code] then
              return diagnostic
            end
          end,
        },
        factory = helpers.generator_factory,
      })

      opts.root_dir = opts.root_dir
        or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.formatting.shfmt,
        nls.builtins.formatting.csharpier.with({
          command = { "/home/kuba/.dotnet/tools/dotnet-csharpier" },
          extra_args = { "--write-stdout" },
          filetypes = { "cs" },
        }),
        nls.builtins.diagnostics.pmd.with({
          args = {
            "check",
            "--format",
            "json",
            "--dir",
            "$ROOT",
          },
          extra_args = {
            "--rulesets",
            "category/java/bestpractices.xml,category/jsp/bestpractices.xml", -- or path
            "--cache=$ROOT/.pmd-cache",
            "--no-progress",
          },
          filetypes = { "java" },
        }),
        nls.builtins.diagnostics.checkstyle.with({
          args = { "-f", "sarif", "$FILENAME" },
          extra_args = { "-c", "$ROOT/checkstyle.xml" },
          filetypes = { "java" },
        }),

        clang_tidy,
      })
    end,
  },
}
