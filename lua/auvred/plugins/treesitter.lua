require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
})

require("treesitter-context").setup({
  max_lines = 7,
})
