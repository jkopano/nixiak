return {
    {
        "oclay1st/maven.nvim",
        cmd = { "Maven", "MavenInit", "MavenExec" },
        ft = "java",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {},
        keys = {
            "<Leader>cM",
            "<cmd>Maven<cr>",
            desc = "Maven",
            ft = "java",
        },
    },
}
