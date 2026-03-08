require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
  },
})

require("treesitter-context").setup({
  max_lines = 7,
})

-- https://github.com/neovim/neovim/pull/22555
vim.filetype.add({ extension = { mdx = 'mdx' } })
vim.treesitter.language.register('markdown', 'mdx')
