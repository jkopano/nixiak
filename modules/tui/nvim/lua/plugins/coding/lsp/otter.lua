return {
  "jmbuhr/otter.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    extensions = {
      ["glsl"] = "glsl",
    },
    buffers = { set_filetype = true },
    lsp = {
      diagnostic_update_event = { "BufWritePost", "InsertLeave" },
    },
  },
}
