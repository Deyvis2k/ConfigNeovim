local Terminal = require('toggleterm.terminal').Terminal
local clang_opt = require("clang_options_window")

--number 
local FALSE = 0
local TRUE = 1

local function AfterPattern(str, pattern)
    local s, e = string.find(str, pattern)
    if s == nil then
        return nil
    end
    return string.sub(str, e + 1)
end

local function get_current_file()
    local filename = vim.api.nvim_buf_get_name(0) 
    if filename == "" then
        print("Sem arquivo no buffer atual")
        return nil
    end
    return filename
end

local file_commands = {
    ["py"] = "python3 %s",
    ["lua"] = "lua %s",
    ["js"] = "node %s",
    ["cs"] = "dotnet run",
    ["axaml"] = "dotnet run",
    ["rs"] = "cargo run",
    ["rb"] = "ruby %s",
    ["go"] = "go run %s",
    ["java"] = require("compiler_lan.java_comp").build_java
    -- ["c"] = clang_opt.create_window_select,
    -- ["cpp"] = clang_opt.create_window_select
}

local build_json_file_content = [[
{
    "build": [
        {
            "label": "build",
            "type": "shell",
            "command": "make",
            "cwd": "build",
            "args": [],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            },
            "problemMatcher": "$gcc"
        }
    ]
}
]]

local task_json_file_content = [[
{
    "tasks": [
        {
            "label": "run-program",
            "type": "shell",
            "command": "./program",
            "cwd": "build",
            "args": [],
            "group": "run",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            },
            "problemMatcher": "$gcc"
        }
    ]
}
]]


local function run_custom_with_task_and_build()
    local current_dir = vim.fn.getcwd()

    if vim.fn.filereadable(current_dir .. "/.nvim_bany/task.json") == FALSE and vim.fn.filereadable(current_dir .. "/.nvim_bany/build.json") == FALSE then
        if vim.fn.isdirectory(current_dir .. "/.nvim_bany") == FALSE then
            vim.fn.mkdir(current_dir .. "/.nvim_bany", "p")
        end

        local task_file = io.open(current_dir .. "/.nvim_bany/task.json", "w+")
        if task_file == nil then
            print("Error opening file")
            return
        end
        task_file:write(task_json_file_content)
        task_file:close()

        local build_file = io.open(current_dir .. "/.nvim_bany/build.json", "w+")
        if build_file == nil then
            print("Error opening file")
            return
        end
        build_file:write(build_json_file_content)
        build_file:close()
        clang_opt.create_window_select()
        return
    end

    clang_opt.create_window_select()
end

local function spawn_terminal_with_command(command)
    local terminal = Terminal:new({ cmd = command, hidden = true, direction = "float" })
    terminal:toggle()
end

local function get_formatted_content_from_build()
     local current_dir = vim.fn.getcwd()
     local file = io.open(current_dir .. "/build.txt", "r")
     if file == nil then
         return nil
     end
     local content = file:read("*all")
     file:close()
     local split_content = vim.split(content, "\n")
     if split_content[1].find(split_content[1], "file_ext") == nil or split_content[2].find(split_content[2], "file_name") == nil then
         return nil
     end
     local file_ext = AfterPattern(split_content[1], "file_ext=")
     local file_name = AfterPattern(split_content[2], "file_name=")
     return {
         file_ext = file_ext,
         file_name = file_name
    }
end

local function RunDeterminedFile()
    local current_dir = vim.fn.getcwd()
    if vim.fn.filereadable(current_dir .. "/build.txt") == 0 then
         local file_ext = vim.fn.input("File extension: ") or ""
         local file_name = vim.fn.input("File to execute name: ") or ""

         if file_ext == "" or file_name == "" then
             Snacks.notify.error("File extension or file name not found")
             return
         end

         file_ext = string.lower(file_ext)
         file_name = string.lower(file_name)

         local file = io.open(current_dir .. "/build.txt", "w+")
         if file == nil then
             print("Error opening file")
             return
         end
         file:write(string.format("file_ext=%s\nfile_name=%s", file_ext, file_name))
         file:close()
         if file_commands[file_ext] == nil then
             run_custom_with_task_and_build()
             return
         else
             local command = string.format(file_commands[file_ext], file_name)
             spawn_terminal_with_command(command)
         end
    else
        local content = get_formatted_content_from_build()
        if content == nil then
            return
        end

        if file_commands[content.file_ext] == nil then
            run_custom_with_task_and_build()
            return
        end

        local command = string.format(file_commands[content.file_ext], content.file_name)
        spawn_terminal_with_command(command)

    end
end


return {
    RunDeterminedFile = RunDeterminedFile
}
