require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  show_end_of_buffer = true,
  custom_highlights = function(colors)
    local U = require("catppuccin.utils.colors")
    return {
      Pmenu = { bg = U.darken(colors.surface0, 0.5, colors.crust) },
      NormalFloat = { bg = U.darken(colors.surface0, 0.5, colors.crust) },
    }
  end,
})

vim.cmd("colorscheme catppuccin")
