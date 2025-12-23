vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.clipboard = "unnamedplus"
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.wrap = false
vim.g.codeium_enabled = false
vim.o.termguicolors = true
vim.opt.laststatus = 3
vim.o.smartcase = true
vim.o.mouse = "a"
vim.o.hlsearch = true
vim.o.scrolloff = 8
vim.o.encoding = 'utf-8'
vim.opt.swapfile = false
vim.g.terminal = 'kitty'
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.g.mapleader = " "
vim.o.history = 1000
vim.o.undodir = vim.fn.stdpath("data") .. "/undo"
vim.o.undofile = true
vim.diagnostic.config{
    virtual_text = true,
    -- virtual_lines = true
}
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.ruler = false
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
--remove the line below statusline
-- vim.cmd([[set noshowmode noshowcmd noruler]])

-- default status feedback
--vim.o.showmode = false
--vim.opt.shortmess:append("F")


vim.g.VM_maps = {
  ['Find Under'] = '<C-d>',
  ['Find Subword Under'] = '<C-d>',
}
