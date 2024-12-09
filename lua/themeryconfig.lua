--themery
require("themery").setup({
    themes = {"tokyonight", "tokyonight-storm", 
              "tokyonight-day", "tokyonight-night", 
              "tokyonight-moon", "onedark",
              "gruvbox", "rose-pine-dawn",
              "rose-pine-moon", "rose-pine",
              "sonokai", "dracula",
              "dracula-soft", "peachpuff",
              "monokai-pro", "monokai-pro-machine",
              "monokai-pro-spectrum","monokai-pro-octagon",
              "monokai-pro-ristretto","monokai-pro-classic",
              "monokai-pro-default", "tokyodark", 
              "sorbet"},
    livepreview = true
})

vim.keymap.set("n", "<leader>ch", ":Themery<CR>", { noremap = true, silent = true })
