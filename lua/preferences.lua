vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.clipboard = "unnamedplus"
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.wrap = false
vim.g.codeium_enabled = true
vim.o.termguicolors = true
vim.o.smartcase = true
vim.o.mouse = "a"
vim.o.hlsearch = true
vim.o.scrolloff = 8
vim.o.encoding = 'utf-8'
vim.opt.swapfile = false 
vim.g.terminal = 'alacritty'

-- default status feedback
vim.o.showmode = false
vim.opt.shortmess:append("F")


vim.g.VM_maps = {
  ['Find Under'] = '<C-d>',
  ['Find Subword Under'] = '<C-d>',
}

