local Terminal = require('toggleterm.terminal').Terminal
require('compiler')


vim.g.mapleader = " "

--nvim tree 
vim.keymap.set("n", "<leader>ee", vim.cmd.NvimTreeToggle)

vim.keymap.set("n", "<leader>ef", function()
    if require("nvim-tree.view").is_visible() then
        vim.api.nvim_command("wincmd w")
    else
        vim.cmd("NvimTreeToggle")
    end
end)



vim.keymap.set("n", "<leader>tt", vim.cmd.ToggleTerm)
vim.keymap.set("n", "<leader>n", ':nohlsearch<CR>', {noremap = true, silent = true})

--replace DD and dd
vim.keymap.set("n", "d", '"_d', {noremap = true})
vim.keymap.set("v", "d", '"_d', {noremap = true})
vim.keymap.set("v", "dd", '"_dd', {noremap = true})


--codeium shortcuts
vim.keymap.set("n", "<leader>cd",
    function()
        local function CodeimToggle()
            if vim.g.codeium_enabled == 1 then
                vim.g.codeium_enabled = 0
                vim.cmd("Codeium Disable")
                print("Codeium Disabled")
            else
                vim.g.codeium_enabled = 1
                vim.cmd("Codeium Enable")
                print("Codeium Enabled")
            end
        end
        CodeimToggle()
end, { expr = true, silent = true })


vim.keymap.set("n", "<leader>d", 'd', {noremap = true})
vim.keymap.set("v", "<leader>d", 'd', {noremap = true})
vim.keymap.set("v", "<leader>dd", 'dd', {noremap = true})

vim.keymap.set("n", "<F5>", ':w<CR> :lua RunDeterminedFile()<CR>', {noremap = true, silent = true})
vim.keymap.set("n", "<leader>ls", ':lua LiveServerToggle()<CR>', {noremap = true, silent = true})

function LiveServerToggle()
    local liveServer = Terminal:new({cmd = "live-server --browser='brave' .", hidden = true})
    liveServer:toggle()
end

vim.keymap.set("i", "<C-s>", function()
	vim.cmd.w()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
end)

--buffers
vim.keymap.set("n", "<leader>cc", vim.cmd.bw)
vim.keymap.set("n", "<leader>h", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>l", vim.cmd.bnext)


--csplugin
vim.api.nvim_set_keymap("n", "<leader>cs", ":lua require'csplugin.csplugin'.show()<CR>", { noremap = true, silent = true })


vim.keymap.set("n", "<leader>zx", function()
        local function print_package_csplugin()
           print(package.loaded["csplugin.csplugin"] or "csplugin.csplugin not loaded")
        end
        print_package_csplugin()
    end, { buffer = buf, nowait = true, noremap = true, silent = true })

function reload_csplugin()
    for plugin_name, _ in pairs(package.loaded) do
        if plugin_name:match("^csplugin") then
            package.loaded[plugin_name] = nil
        end
    end
    local success, reloaded_plugin = pcall(require,"csplugin.csplugin")
    if success then
        vim.api.nvim_set_keymap("n", "<leader>cs", ":lua require'csplugin.csplugin'.show()<CR>", { noremap = true, silent = true })
        print("csplugin recarregado com sucesso!")
    else
        print("Erro ao recarregar csplugin:", reloaded_plugin)
    end
end


--reload csplugin
vim.api.nvim_set_keymap("n", "<leader>rcs", ":lua reload_csplugin()<CR>", { noremap = true, silent = true })

