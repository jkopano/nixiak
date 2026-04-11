return {
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      local function check_if_lazy(...)
        if vim.bo.filetype == "lazygit" or vim.bo.filetype == "terminal" then
          local arr = ...
          return string.format("<c-v>%s<c-v>%s", arr[1], arr[2])
        end
        return "<esc>"
      end
      require("better_escape").setup({
        timeout = 200,
        default_mappings = false,
        mappings = {
          i = {
            j = {
              k = check_if_lazy("j", "k"),
              j = check_if_lazy("j", "j"),
            },
            k = {
              j = check_if_lazy("k", "j"),
              k = check_if_lazy("k", "k"),
            },
          },
          c = {
            j = {
              j = check_if_lazy("j", "j"),
              k = check_if_lazy("j", "k"),
            },
            k = {
              j = check_if_lazy("k", "j"),
              k = check_if_lazy("k", "k"),
            },
          },
        },
      })
    end,
  },
}
