require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  show_end_of_buffer = true,
  color_overrides = {
    mocha = {
      surface1 = "#9499b5",
    },
  },
  custom_highlights = function(colors)
    local U = require("catppuccin.utils.colors")
    return {
      Pmenu = { bg = U.darken(colors.surface0, 0.5, colors.crust) },
      NormalFloat = { bg = U.darken(colors.surface0, 0.5, colors.crust) },
    }
  end,
})

vim.cmd("colorscheme catppuccin")
