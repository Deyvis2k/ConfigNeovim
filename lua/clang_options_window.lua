local function delete_if_valid(buf, win)
    if buf == nil or win == nil then
        return
    end

    if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
    end
    if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
    end
end

local function indexof(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end

local keys_bindings = {
    {"<Down>", "j"},
    {"<Up>", "k"},
}


local clang_c = {}
clang_c.__index = clang_c
clang_c.options = {
    "Build",
    "Run",
    "Build and Run"
}

clang_c.win = nil
clang_c.win_buf = nil
clang_c.selected_option = 1

function clang_c:set_selected_option(option)
    self.selected_option = option
end

local function create_window_select()
    local win_width = vim.o.columns
    local win_height = vim.o.lines

    local width, height = 23 , #clang_c.options
    local win_x = math.floor((win_width - width) / 2)
    local win_y = math.floor((win_height - height) / 2)

    clang_c.win_buf = vim.api.nvim_create_buf(false, true)
    local lines = {}
    for i, opt in ipairs(clang_c.options) do
        table.insert(lines, i .. ". " .. opt)
    end

    clang_c.win_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(clang_c.win_buf, 0, -1, false, lines)

    clang_c.win = vim.api.nvim_open_win(clang_c.win_buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = win_y,
        col = win_x,
        style = "minimal",
        title = "Options",
        title_pos = "left",
        border = "single",
    })

    vim.api.nvim_set_option_value("modifiable", false, { buf = clang_c.win_buf })
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = clang_c.win_buf })
    vim.api.nvim_set_option_value("buflisted", false, { buf = clang_c.win_buf })

    local last_option_line = indexof(clang_c.options, clang_c.selected_option) or 1
    vim.api.nvim_win_set_cursor(clang_c.win, { last_option_line , 0 })

    for i, key in ipairs(keys_bindings) do
        local delta = (i == 1) and 1 or -1
        for _, k in ipairs(key) do
            vim.api.nvim_buf_set_keymap(clang_c.win_buf, "n", k, "", {
                noremap = true,
                callback = function()
                    local cur = vim.api.nvim_win_get_cursor(clang_c.win)[1]
                    cur = cur + delta
                    if cur > #clang_c.options  then cur = 1 end
                    if cur < 1 then cur = #clang_c.options end
                    vim.api.nvim_win_set_cursor(clang_c.win, { cur, 0 })
                end
            })
        end
    end

    vim.api.nvim_create_autocmd("WinClosed", {
        buffer = clang_c.win_buf,
        callback = function()
            delete_if_valid(clang_c.win_buf, clang_c.win)
            clang_c.vargs_can_focus = false
        end
    })

     vim.api.nvim_create_autocmd("BufLeave", {
        callback = function()
            local cur_win = vim.api.nvim_get_current_win()
            if cur_win == clang_c.win then
                vim.schedule(function()
                    local current_buf = nil
                    if vim.api.nvim_win_is_valid(cur_win) then current_buf = vim.api.nvim_win_get_buf(cur_win) end
                    if current_buf ~= clang_c.win_buf then
                        if(vim.api.nvim_buf_is_valid(clang_c.win_buf)) then vim.api.nvim_win_set_buf(cur_win, clang_c.win_buf) end
                    end
                end)
            end
        end
    })

    vim.api.nvim_buf_set_keymap(clang_c.win_buf, "n", "q", "", {
        noremap = true,
        callback = function()
            delete_if_valid(clang_c.win_buf, clang_c.win)
        end
    })

    clang_c:select_option()

end

function clang_c:select_option()
    vim.keymap.set("n", "<CR>", function()
        local current_cursor = vim.api.nvim_win_get_cursor(clang_c.win)
        local line = current_cursor[1]

        local option = clang_c.options[line] or "error"
        self:set_selected_option(option)

        delete_if_valid(clang_c.win_buf, clang_c.win)

        local nvim_dir = vim.fn.expand("~/.config/nvim")

        local formatted_cmd = string.format(
            "python3 %s/shellscripts/run_c_anywhere.py '%s'",
            nvim_dir,
            option
        )

        local prev_win = vim.api.nvim_get_current_win()

        vim.api.nvim_set_current_win(prev_win)

        local term_buf = vim.api.nvim_create_buf(false, true)
        vim.cmd("botright split")
        local term_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_height(term_win, 20)
        vim.api.nvim_win_set_buf(term_win, term_buf)

        vim.fn.termopen(formatted_cmd, {
            buf = term_buf
        })

        vim.api.nvim_set_option_value("buftype", "terminal", { buf = term_buf })
        vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = term_buf })
        vim.api.nvim_set_option_value("buflisted", false, { buf = term_buf })

        vim.api.nvim_set_current_win(prev_win)
    end, { noremap = true, silent = true })
end

return {
    create_window_select = create_window_select
}
