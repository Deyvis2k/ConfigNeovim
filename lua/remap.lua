vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>t", vim.cmd.ToggleTerm)
vim.keymap.set("n", "<leader>n", ':nohlsearch<CR>', {noremap = true, silent = true})


--replace DD and dd
vim.keymap.set("n", "d", '"_d', {noremap = true})
vim.keymap.set("v", "d", '"_d', {noremap = true})
vim.keymap.set("v", "dd", '"_dd', {noremap = true})

vim.keymap.set("n", "<leader>d", 'd', {noremap = true})
vim.keymap.set("v", "<leader>d", 'd', {noremap = true})
vim.keymap.set("v", "<leader>dd", 'dd', {noremap = true})


vim.keymap.set("n", "<leader>ls", ':lua LiveServerToggle()<CR>', {noremap = true, silent = true})

function LiveServerToggle()
    local Terminal = require('toggleterm.terminal').Terminal
    local liveServer = Terminal:new({cmd = "live-server --browser='firefox' .", hidden = true})
    liveServer:toggle()
end

vim.keymap.set("i", "<C-s>", function()
	vim.cmd.w()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
end)

--buffers
vim.keymap.set("n", "<leader>c", vim.cmd.bw)
vim.keymap.set("n", "<leader>h", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>l", vim.cmd.bnext)

