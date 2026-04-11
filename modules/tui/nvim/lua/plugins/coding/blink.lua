return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.completion.trigger = {}
    opts.sources.providers.codeium.score_offset = 100
    opts.completion.trigger = {
      prefetch_on_insert = false,
      show_in_snippet = true,
      show_on_keyword = false,
      show_on_trigger_character = false,
    }

    opts.keymap = {
      ["<C-l>"]  = { "accept", "snippet_forward", "fallback" },
      ["<C-j>"]  = { "show", "select_next", "fallback" },
      ["<C-k>"]  = { "select_prev", "fallback" },
      ["<C-h>"]  = { "snippet_backward" },
      ["<CS-j>"] = { "scroll_documentation_down", "fallback" },
      ["<CS-k>"] = { "scroll_documentation_up", "fallback" },
      ["<CR>"]   = { "accept", "fallback" },
      ["<C-e>"]  = { "hide" },
    }
  end,
}
