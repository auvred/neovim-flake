require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  float = {
    transparent = true,
  },
  show_end_of_buffer = true,
  lsp_styles = {
    underlines = {
      errors = { "undercurl" },
    },
  },
})

vim.cmd("colorscheme catppuccin")
