--themery
require("themery").setup({
    themes = {"tokyonight", "tokyonight-storm", 
              "tokyonight-day", "tokyonight-night", 
              "tokyonight-moon", "onedark",
              "gruvbox", "rose-pine-dawn",
              "rose-pine-moon", "rose-pine",
              "sonokai", "dracula",
              "dracula-soft",
              "monokai-pro", "tokyodark",},
    livepreview = true
})

vim.keymap.set("n", "<leader>ch", ":Themery<CR>", { noremap = true, silent = true })

