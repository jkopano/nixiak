return {
    {
        "nvimtools/none-ls.nvim",
        enabled = false,
        opts = function(_, opts)
            local nls = require("null-ls")
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
            })
        end,
    },
}
