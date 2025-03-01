local Terminal = require('toggleterm.terminal').Terminal

local function get_current_file()
    local filename = vim.api.nvim_buf_get_name(0)  -- Pega o nome completo do arquivo no buffer atual
    if filename == "" then
        print("Sem arquivo no buffer atual")
        return nil
    end
    return filename
end


local usrname = os.getenv("USER")
local nvim_dir = "/home/" .. usrname .. "/.config/nvim"

function ChangeBuildContent()
    local file = io.open("/home/deyvis/.config/nvim/temp/build.txt", "w")
    if file == nil then
        return
    end
    local current_file = vim.fn.getcwd()
    local content = vim.fn.input("Enter content: ", current_file)
    file:write(content)
    file:close()
end




local file_commands = {
    ["py"] = "python3 %s",
    ["lua"] = "lua %s",
    ["js"] = "node %s",
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


function RunDeterminedFile()
    local file_ext = vim.fn.expand('%:e')
    local filename = get_current_file()
    if not filename then
        return
    end

    if file_ext == "c" or file_ext == "cpp" then
        --checks if already exists build.txt and has content
        if vim.fn.filereadable("/home/deyvis/.config/nvim/temp/build.txt") == 1 and has_content("/home/deyvis/.config/nvim/temp/build.txt") then
            print("If you want to change build.txt enters the command: :lua ChangeBuildContent()")
        else
            local current_dir = vim.fn.getcwd()
            local binary_path = vim.fn.input("Binary name: ", current_dir)

            --create build.txt
            local build_file = io.open("/home/deyvis/.config/nvim/temp/build.txt", "w")
            if build_file == nil then
                print("Error opening file")
                return
            end
            build_file:close()

            local file = io.open("/home/deyvis/.config/nvim/temp/build.txt", "w+")

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
    if command then
        local term = Terminal:new({hidden = true})
        term:toggle()

        vim.defer_fn(function()
          term:send(string.format(command, filename))
        end, 100)
    else
        print("File type not supported")
    end
end

