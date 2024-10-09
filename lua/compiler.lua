local Terminal = require('toggleterm.terminal').Terminal

local function get_current_file()
    local filename = vim.api.nvim_buf_get_name(0)  -- Pega o nome completo do arquivo no buffer atual
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
    ["rs"] = "cargo run",
    ["go"] = "go run %s",
    ["java"] = "~/.config/nvim/shellscripts/run_java.sh %s",
    ["c"] = "~/.config/nvim/shellscripts/run_clanguage.sh %s",
    ["cpp"] = "~/.config/nvim/shellscripts/run_clanguage.sh %s"
}

function RunDeterminedFile()
    local file_ext = vim.fn.expand('%:e')
    local filename = get_current_file()
    if not filename then
        return
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

