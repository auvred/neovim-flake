vim.api.nvim_create_autocmd('FileType', { 
  callback = function() 
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" 
  end, 
}) 
require("treesitter-context").setup({
  max_lines = 7,
})

-- https://github.com/neovim/neovim/pull/22555
vim.filetype.add({ extension = { mdx = 'mdx' } })
vim.treesitter.language.register('markdown', 'mdx')
