local Terminal = require('toggleterm.terminal').Terminal
local compil = require('compiler')

-- neo tree
vim.keymap.set("n", "<leader>e", ":lua Snacks.explorer.open()<CR>", { noremap = true, silent = true })

-- comment nvim
vim.keymap.set("n", "<leader>\\", require("Comment.api").toggle.linewise.current)
vim.keymap.set("v", "<leader>\\", require("Comment.api").call('toggle.linewise', 'g@'), { expr = true })

vim.keymap.set("n", "<leader>lg", ':lua Snacks.lazygit.open()<CR>', { noremap = true, silent = true })

--debug
vim.keymap.set("n", "<F4>", require("dap").toggle_breakpoint)
vim.keymap.set("n", "<F6>", require("dap").continue)
vim.keymap.set("n", "<F7>", require("dap").step_over)
vim.keymap.set("n", "<F8>", require("dap").step_into)
vim.keymap.set("n", "<F9>", require("dap").step_out)
vim.keymap.set("n", "<leader>dr", require("dap").repl.open)

vim.keymap.set({ 'n', 't' }, '<leader>ld', '<Cmd>lua LazyDocker.toggle()<CR>')

--visual debug
vim.keymap.set("n", "<leader>duo", require("dapui").open)
vim.keymap.set("n", "<leader>duc", require("dapui").close)

vim.keymap.set("n", "<Leader>ng", ":NuGet<CR>", {noremap= true, silent = true})

--ctrl a like 
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true })

vim.keymap.set("n", "<leader>tt", ":ToggleTerm direction=float <CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>n", ':nohlsearch<CR>', { noremap = true, silent = true })

--replace DD and dd
vim.keymap.set("n", "d", '"_d', { noremap = true })
vim.keymap.set("v", "d", '"_d', { noremap = true })
vim.keymap.set("v", "dd", '"_dd', { noremap = true })

--codeium shortcuts
-- codeium shortcuts
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


vim.keymap.set("n", "<leader>d", 'd', { noremap = true })
vim.keymap.set("v", "<leader>d", 'd', { noremap = true })
vim.keymap.set("v", "<leader>dd", 'dd', { noremap = true })

vim.keymap.set("n", "<F5>", function() compil.RunDeterminedFile() end, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ls", ':lua LiveServerToggle()<CR>', { noremap = true, silent = true })

function LiveServerToggle()
    local liveServer = Terminal:new({
        -- cmd = "live-server --browser='firefox' .",
        cmd = string.format("live-server --browser='firefox' %s", vim.fn.expand("%:p:h")),
        hidden = false,
        direction = "float",
        close_on_exit = false
    })
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
vim.keymap.set("n", "<leader>l", ":bnext<CR>:redraw!<CR>", { silent = true })


--csplugin
vim.api.nvim_set_keymap("n", "<leader>cs", ":lua require'csplugin.csplugin'.show()<CR>",
    { noremap = true, silent = true })


local Terminal = require("toggleterm.terminal").Terminal

vim.keymap.set("n", "<leader>mm", function()
    local dir_name = vim.fn.getcwd()
    local csproj_file = vim.fn.globpath(dir_name, "*.csproj", false, true)[1] or ""

    if csproj_file == "" then
        print("Erro: Nenhum arquivo .csproj encontrado no diretório atual.")
        return
    end

    local model_name = vim.fn.input("Nome do modelo: ")
    local data_context = vim.fn.input("DataContext: ")
    local controller_name = vim.fn.input("Nome do controlador: ")

    if (model_name == "" or data_context == "" or controller_name == "") then
        return
    end

    local project_name = csproj_file:match("([^/]+)%.csproj$")
    local namespace = project_name and (project_name .. ".Controller") or "DefaultNamespace.Controllers"

    local command = string.format(
        'dotnet aspnet-codegenerator controller --project "%s" --controllerName %s --relativeFolderPath "%s/Controller" --restWithNoViews --model %s --dataContext %s --controllerNamespace %s; exec $SHELL',
        csproj_file, controller_name, dir_name, model_name, data_context, namespace
    )

    local toggleterm = Terminal:new({
        cmd = command,
        direction = "float",
        close_on_exit = false,
        hidden = false
    })

    toggleterm:toggle()
end, { noremap = true, silent = true, desc = "Executar dotnet aspnet-codegenerator" })



vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { noremap = true, silent = true , desc = "Executar DBUI" })

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
    local success, reloaded_plugin = pcall(require, "csplugin.csplugin")
    if success then
        vim.api.nvim_set_keymap("n", "<leader>cs", ":lua require'csplugin.csplugin'.show()<CR>",
            { noremap = true, silent = true })
        print("csplugin recarregado com sucesso!")
    else
        print("Erro ao recarregar csplugin:", reloaded_plugin)
    end
end

--reload csplugin
vim.api.nvim_set_keymap("n", "<leader>rcs", ":lua reload_csplugin()<CR>", { noremap = true, silent = true })
