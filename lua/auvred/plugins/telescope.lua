local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", function()
  builtin.find_files({ hidden = true })
end, {})

vim.keymap.set("n", "<leader>fg", function()
  builtin.live_grep({ additional_args = { "--hidden" } })
end, {})
