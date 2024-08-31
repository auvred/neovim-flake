vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      timeout = 140,
    })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*",
  callback = function()
    vim.o.formatoptions = "ro/jq"
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  pattern = "*",
  callback = function()
    vim.cmd("wincmd =")
  end,
})
