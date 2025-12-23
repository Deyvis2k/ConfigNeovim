local Terminal = require('toggleterm.terminal').Terminal
local used_snack = false
local clang_opt = require("compiler_lan.clang_options_window")


local function get_current_file()
    local filename = vim.api.nvim_buf_get_name(0) 
    if filename == "" then
        print("Sem arquivo no buffer atual")
        return nil
    end
    return filename
end


local function AfterPattern(str, pattern)
    local s, e = string.find(str, pattern)
    if s == nil then
        return nil
    end
    return string.sub(str, e + 1)
end


local usrname = os.getenv("USER")
local nvim_dir = "/home/" .. usrname .. "/.config/nvim"
local current_dir = vim.fn.getcwd()

function ChangeBuildContent()

    local file_to_read = io.open(current_dir .. "/build.txt", "r")
    if file_to_read == nil then
        return
    end

    local content = file_to_read:read("*all")
    local split_content = vim.split(content, "\n")
    local filename_path_from_file = AfterPattern(split_content[1], "filename_path= ")
    file_to_read:close()

    local file = io.open(current_dir .. "/build.txt", "w+")
    if file == nil then
        return
    end
    local filename_path = vim.fn.input("Binary path name: ", filename_path_from_file)
    local executable_name = vim.fn.input("Executable name: ")
    file:write(string.format("filename_path= %s\nexecutable_name= %s", filename_path, executable_name))
    file:close()
end

local function find_package_json()
    local package_json_path = vim.fn.findfile("package.json", ".;")

    if package_json_path ~= "" then
        print("Found package.json at: " .. package_json_path)
        return package_json_path
    else
        print("No package.json found")
        return nil
    end
end

local function yarn_develop_in_toggleterm()
    local package_json_path = find_package_json()

    if package_json_path then
        local package_dir = vim.fn.fnamemodify(package_json_path, ":h")
        print("Running yarn develop in " .. package_dir)

        local toggleterm = Terminal:new({
            cmd = "cd " .. package_dir .. " && yarn develop",
            direction = "float",
            close_on_exit = false,
            hidden = false
        })
        toggleterm:toggle()
    else
        print("No package.json found, cannot run yarn develop")
    end
end




local file_commands = {
    ["py"] = "python3 %s",
    ["lua"] = "lua %s",
    ["js"] = "node %s",
    ["ts"] = yarn_develop_in_toggleterm,
    ["cs"] = "dotnet run",
    ["axaml"] = "dotnet run",
    ["rs"] = "cargo run",
    ["rb"] = "ruby %s",
    ["go"] = "go run %s",
    ["java"] = require("compiler_lan.java_comp").build_java,
    ["c"] = clang_opt.create_window_select,
    ["cpp"] = clang_opt.create_window_select
}

local function has_content(file_path)
    local file = io.open(file_path, "r")
    if file == nil then
        return false
    end
    local content = file:read("*all")
    file:close()
    return content ~= ""
end

local function BuildFileIsWellFormated()
    local file = io.open(current_dir .. "/build.txt", "r")
    if file == nil then
        return false
    end
    local content = file:read("*all")
    file:close()
    local split_content = vim.split(content, "\n")
    return
        split_content[1].find(split_content[1], "filename_path") ~= nil 
        and split_content[2].find(split_content[2], "executable_name") ~= nil
end

local function RunDeterminedFile()
    local file_ext = vim.fn.expand('%:e')
    local filename = get_current_file()
    if not filename then
        return
    end

    if file_ext == "c" or file_ext == "cpp" then
        if vim.fn.filereadable(current_dir .. "/build.txt") == 1 and has_content(current_dir .. "/build.txt")
            and BuildFileIsWellFormated()
        then
            if not used_snack then
                Snacks.notify.info("If u want change the variables at build.txt\nthen execute ChangeBuildContent")
                used_snack = true
            end
        else
            local binary_path = vim.fn.input("Binary path name: ", current_dir)
            local executable_name = vim.fn.input("Executable name: ")
            local build_file = io.open(current_dir .. "/build.txt", "w+")
            if build_file == nil then
                print("Error opening file")
                return
            end
            build_file:close()

            local file = io.open(current_dir .. "/build.txt", "w+")
            if file == nil then
                print("Error opening file")
                return
            end
            file:write(string.format("filename_path= %s\nexecutable_name= %s", binary_path, executable_name))
            print("write at temp/build.txt: " .. binary_path)
            file:close()
        end
    end

    local command = file_commands[file_ext]

    if command and type(command) == "function" then
        if file_ext == "c" or file_ext == "cpp" then
            command(clang_opt, nvim_dir, filename)
        else
            command()
        end
        return
    end

    if command and type(command) == "string" then
        local formatted_cmd = string.format(command, filename)

        local term = Terminal:new({
            cmd = formatted_cmd,
            direction = "float",
            close_on_exit = false,
            hidden = false
        })

        if term then
            term:toggle()
        else
            print("Erro: Falha ao inicializar o terminal")
        end
    else
        print("File type not supported")
    end
end


return {
    RunDeterminedFile = RunDeterminedFile
}
