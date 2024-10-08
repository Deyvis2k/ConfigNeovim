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


local file_commands = {
    ["py"] = ":!python3 %",
    ["lua"] = ":!lua %",
    ["js"] = "!node %",
    ["cs"] = ":!dotnet run",
    ["rs"] = ":!cargo run",
    ["go"] = ":!go run %",
}

function RunDeterminedFile()
    local file_ext = vim.fn.expand('%:e')
    if file_commands[file_ext] ~= nil then
        vim.cmd(file_commands[file_ext])
    else
        print("File type not supported")
    end
end

vim.keymap.set("n", "<F5>", ':w<CR> :lua RunDeterminedFile()<CR>', {noremap = true, silent = true})
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

