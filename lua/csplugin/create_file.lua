local create = {}

create.__index = create


local function FileExists(path)
    local f = io.open(path, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local function is_alphabetic(name)
    return name:find("[^%a]") ~= nil
end



local function create_window_input(prompt, on_submit)
    local buf = vim.api.nvim_create_buf(false, true)

    local width, height = 50, 3
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
        title = "Input (Cannot be empty or not alphabetic)",
        title_pos = "center",
        --border not rounded
        border = "rounded",
    })
    
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {prompt})
    vim.api.nvim_buf_set_lines(buf, 1, -1, false, {""})

    --options
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_option(buf, "buftype", "prompt")

    vim.api.nvim_command("startinsert!")


    _G.SubmitInput = function()
        local lines = vim.api.nvim_buf_get_lines(buf, 1, 2, false)
        local input = lines[1] or ""

        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, {force = true})


        if on_submit then
            on_submit(input)
        end
    end

    _G.CloseInput = function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, {force = true})
    end

    
    vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", [[<cmd>lua SubmitInput()<CR>]], { nowait = true, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", [[<cmd>lua CloseInput()<CR>]], { nowait = true, noremap = true, silent = true }) 
end

local csharp_prefix = [[
using System;

namespace Foo;

public class Program
{
    public static void Main(string[] args)
    {
        Console.WriteLine("Hello World!");
    }
}
]]

function create.create_file()
    create_window_input("Enter filename:", function(filename)
        if filename == nil or filename == "" then
            print("Filename cannot be empty")
            return
        end

        local extension = ""

        if require("csplugin.chooselanguage").current_language ~= nil then
            extension = require("csplugin.chooselanguage").current_language
        end

        local actual_dir = vim.fn.expand("%:p:h")
        if actual_dir == "" then
            actual_dir = vim.fn.getcwd()
        end

        local name = filename:gsub("[^%a]", "")
        if FileExists(name) then
            print("File already exists")
        else
            local file = io.open(actual_dir .. "/" .. name .. extension, "w")
            if file then
                if extension == ".cs" then
                    print("Creating C# file...")
                    file:write(csharp_prefix)
                    io.close(file)
                else
                    print("Creating file...")
                    io.close(file)
                end
            else
                print("Error creating file:", name)
            end
        end
    end)
end

return create
