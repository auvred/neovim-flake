vim.api.nvim_create_autocmd('FileType', { 
  callback = function() 
    -- don't crash on oil:// files
    local ok = pcall(vim.treesitter.start)
    if ok then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" 
    end
  end, 
}) 
require("treesitter-context").setup({
  max_lines = 7,
})

-- https://github.com/neovim/neovim/pull/22555
vim.filetype.add({ extension = { mdx = 'mdx' } })
vim.treesitter.language.register('markdown', 'mdx')
