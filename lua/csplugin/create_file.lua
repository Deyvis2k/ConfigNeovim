
local create = {}

create.__index = create
create.current_dir = vim.fn.expand("%:p:h")
create.is_windowopen = false

local function ensure_directory(path)
    local dir = vim.fn.fnamemodify(path, ":h")
    if dir and not vim.fn.isdirectory(dir) then
        vim.fn.mkdir(dir, "p")
    end
end

local function create_window_input(on_submit)
    local buf = vim.api.nvim_create_buf(false, true)
    create.is_windowopen = true

    local width, height = 50, 1
    local win_width = vim.o.columns
    local win_height = vim.o.lines
    local win_x = math.floor((win_width - width) / 2)
    local win_y = math.floor((win_height - height) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = win_y,
        col = win_x,
        style = "minimal",
        title = "Enter filename",
        title_pos = "center",
        border = "rounded",
    })

    local current_dir = create.current_dir .. "/"

    vim.api.nvim_buf_set_lines(buf, 0, 1, false, {current_dir})
    vim.api.nvim_buf_set_option(buf, "modifiable", true)

    vim.api.nvim_command("startinsert!")

    _G.SubmitInput = function()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local input = lines[1] or ""

        print(input)

        if on_submit then
            on_submit(input)
        end
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, {force = true})
    end

    _G.CloseInput = function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, {force = true})
    end

    vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", [[<cmd>lua SubmitInput()<CR>]], {nowait = true, noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", [[<cmd>lua CloseInput()<CR>]], {nowait = true, noremap = true, silent = true})
end

function create.create_file()
    create_window_input(function(filename)
        if filename == nil or filename == "" then
            print("Filename cannot be empty")
            return
        end

        local language_module = require("csplugin.chooselanguage")
        local extension = language_module and language_module.current_language or ""

        ensure_directory(filename)

        local splited = vim.split(filename, "/")
        local name = splited[#splited]
        name = name:sub(1, 1):upper() .. name:sub(2)
        local csharp_prefix = [[
using System;

namespace Foo;

public class ]] .. name .. [[
{
    public ]] .. name .. [[() {}
}
]]
        local file = io.open(filename .. extension, "w+")
        if extension == ".cs" then file:write(csharp_prefix) end
        file:close()
    end)
end

return create
