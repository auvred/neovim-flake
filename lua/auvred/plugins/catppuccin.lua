require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  show_end_of_buffer = true,
  color_overrides = {
    mocha = {
      surface1 = "#9499b5",
    },
  },
})

vim.cmd("colorscheme catppuccin")
