local Terminal = require('toggleterm.terminal').Terminal

local function get_current_file()
    local filename = vim.api.nvim_buf_get_name(0) -- Pega o nome completo do arquivo no buffer atual
    if filename == "" then
        print("Sem arquivo no buffer atual")
        return nil
    end
    return filename
end


local usrname = os.getenv("USER")
local nvim_dir = "/home/" .. usrname .. "/.config/nvim"
local current_dir = vim.fn.getcwd()

local function ChangeBuildContent()
    local file = io.open(current_dir .. "/build.txt", "w")
    if file == nil then
        return
    end
    local current_file = vim.fn.getcwd()
    local content = vim.fn.input("Enter content: ", current_file)
    file:write(content)
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
    ["go"] = "go run %s",
    ["java"] = "~/.config/nvim/shellscripts/run_java.sh %s",
    ["c"] = nvim_dir .. "/shellscripts/run_clanguage.sh %s",
    ["cpp"] = nvim_dir .. "/shellscripts/run_clanguage.sh %s",
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

local function RunDeterminedFile()
    local file_ext = vim.fn.expand('%:e')
    local filename = get_current_file()
    if not filename then
        return
    end

    if file_ext == "c" or file_ext == "cpp" then
        if vim.fn.filereadable(current_dir .. "/build.txt") == 1 and has_content(current_dir .. "/build.txt") then
            print("If you want to change build.txt, enter the command: :lua ChangeBuildContent()")
        else
            local binary_path = vim.fn.input("Binary name: ", current_dir)
            local build_file = io.open(current_dir .. "/build.txt", "w+")
            if build_file == nil then
                print("Error opening file")
                return
            end
            build_file:close()

            local file = io.open(current_dir .. "/build.txt", "a")
            if file == nil then
                print("Error opening file")
                return
            end
            file:write(binary_path)
            print("write at temp/build.txt: " .. binary_path)
            file:close()
        end
    end

    local command = file_commands[file_ext]

    if command and type(command) == "function" then
        command()
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
    RunDeterminedFile = RunDeterminedFile,
    ChangeBuildContent = ChangeBuildContent
}
