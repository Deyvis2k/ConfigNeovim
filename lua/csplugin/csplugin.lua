local csplugin = {}
local create = require("csplugin.create_file")
local choose = require("csplugin.chooselanguage")

function csplugin.show()
    local opts = { "Create new file", "Select language" ,  "Leave" }
    local bufnr = vim.api.nvim_create_buf(false, true)

    local width, height = 30, #opts

    local win_opts = {
        relative = "editor",
        width = width,
        height = height,
        --title
        title = "Select an option",
        title_pos = "center",
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        --style not minimal
        style = "minimal",
        border = "rounded",
    }

    local win_id = vim.api.nvim_open_win(bufnr, true, win_opts)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, opts)    
    vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
    vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")

    vim.keymap.set("n", "<CR>", function()
        csplugin.select(opts)
    end, { buffer = bufnr, nowait = true, noremap = true, silent = true })

    csplugin.win_id = win_id
    csplugin.bufnr = bufnr
end

function csplugin.select(options)
    local mouse_cursor = vim.api.nvim_win_get_cursor(0)
    local line = mouse_cursor[1]

    if options[line] then
        if line == #options then
            vim.api.nvim_win_close(csplugin.win_id, true)
            create.is_windowopen = false
        elseif line == 1 then
            create.create_file()
        elseif line == 2 then
            choose.create_window_select()
        end
    end
end

if not create.is_windowopen then
    create.current_dir = vim.fn.expand("%:p:h")
end

return csplugin
