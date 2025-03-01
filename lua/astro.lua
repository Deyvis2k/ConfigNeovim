require("astrotheme").setup({
  palette = "astrolight",
  background = {
    light = "astrolight",
    dark = "astrodark",
  },

  style = {
    transparent = false,
    inactive = true,
    float = true,
    neotree = true,
    border = true,
    title_invert = true,
    italic_comments = true,
    simple_syntax_colors = true,
  },
  termguicolors = true,
  terminal_color = true,
  plugin_default = "auto",
  plugins = {
        ["bufferline.nvim"] = false,
  },
})
