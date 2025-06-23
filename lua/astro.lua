require("astrotheme").setup({
  palette = "astrodark",
  background = {
    light = "astrolight",
    dark = "astrodark",
  },

  style = {
    transparent = false,
    inactive = true,
    float = true,
    neotree = true,
    border = false,
    title_invert = false,
    italic_comments = true,
    simple_syntax_colors = true,
  },
  termguicolors = true,
  terminal_color = true,
  plugin_default = "auto",
  plugins = {
        ["bufferline.nvim"] = true,
  },
})
