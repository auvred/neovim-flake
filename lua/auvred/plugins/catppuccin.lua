require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  float = {
    transparent = true,
  },
  show_end_of_buffer = true,
  integrations = {
    native_lsp = {
      underlines = {
        errors = { "undercurl" },
      },
    },
  },
})

vim.cmd("colorscheme catppuccin")
