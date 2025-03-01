local choose  = {}
choose.__index = choose

choose.current_language = ".txt"
choose.first_interection = true

function choose:create_window_select()

    if choose.first_interection then
        print("default language: " .. choose.current_language:gsub("[^%a]", ""))
        choose.first_interection = false
    end

    local language_options = {
        "cs",
        "cpp",
        "java",
        "py",
        "c",
        "go",
        "js"
    }
    local buf = vim.api.nvim_create_buf(false, true)
    local width, height = 20, #language_options
    local win_width = vim.o.columns
    local win_height = vim.o.lines
    local win_x = math.floor((win_width - width) / 2)
    local win_y = math.floor((win_height - height) / 2)


    local win_options = {
        relative = "editor",
        width = width,
        height = height,
        row = win_y,
        col = win_x,
        style = "minimal",
        title = "Select language",
        title_pos = "center",
        border = "rounded",
    }

    local win_id = vim.api.nvim_open_win(buf, true, win_options)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, language_options)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")


    vim.keymap.set("n", "<CR>", function()
        choose:select(language_options)
    end, { buffer = buf, nowait = true, noremap = true, silent = true })

    vim.keymap.set("n", "<Esc>", function()
        local function close()
            vim.api.nvim_win_close(win_id, true)
            vim.api.nvim_buf_delete(buf,{force = true})
        end
        close()
    end, { buffer = buf, nowait = true, noremap = true, silent = true })

    return win_id
end


function choose:select(language_options)
    local mouse_cursor = vim.api.nvim_win_get_cursor(0)
    local line = mouse_cursor[1]

    if language_options[line] then
        print("Language selected: " .. language_options[line])
        choose.current_language = "." .. language_options[line]
    end
end


return choose

