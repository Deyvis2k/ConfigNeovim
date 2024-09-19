function ChangeColors(color)
   color = color or "sonokai"
   vim.cmd.colorscheme(color)

   vim.api.nvim_set_hl(0, "Normal", {bg = ""})
   vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
end

ChangeColors()
