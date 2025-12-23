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

local function AfterPattern(str, pattern)
    local s, e = string.find(str, pattern)
    if s == nil then
        return ""
    end
    return string.sub(str, e + 1)
end


local _clang_c = {}
_clang_c.__index = _clang_c

_clang_c.vargs_data = ""
_clang_c.use_htop = false
_clang_c.terminal_htop_buf = nil
_clang_c.terminal_htop_win = nil

--@type string[]
_clang_c.options = {
    "Run with Gdb",
    "Run with Valgrind",
    "Run with Lldb",
    "Run Normally",
}

local keys_bindings = {
    {"<Down>", "j"},
    {"<Up>", "k"},
}

function _clang_c:set_selected_option(option)
    self.selected_option = option
end

function _clang_c:get_selected_option()
    return self.selected_option
end

local function indexof(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end

function _clang_c:create_window_select(nvim_dir, filename)
    local win_width = vim.o.columns
    local win_height = vim.o.lines

    _clang_c.vargs_buf = vim.api.nvim_create_buf(false, true)
    _clang_c.vargs_can_focus = false
    local vargs_width = 23
    local vargs_height = 1
    local vargs_win_x = math.floor((win_width - vargs_width) / 2)
    local vargs_win_y = math.floor((win_height - vargs_height) / 2) + 4

    _clang_c.vargs_win = vim.api.nvim_open_win(_clang_c.vargs_buf, true, {
        relative = "editor",
        width = vargs_width,
        height = vargs_height,
        row = vargs_win_y,
        col = vargs_win_x,
        style = "minimal",
        border = "single",
        title = "Extra args[2]",
        title_pos = "left",
        focusable = _clang_c.vargs_can_focus,
        zindex = 200,
    })
    vim.api.nvim_buf_set_lines(_clang_c.vargs_buf, 0, -1, false, { _clang_c.vargs_data })
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = _clang_c.vargs_buf })
    vim.api.nvim_set_option_value("modifiable", false, { buf = _clang_c.vargs_buf })
    vim.api.nvim_create_autocmd("BufEnter", {
        buffer = _clang_c.vargs_buf,
        callback = function()
            vim.api.nvim_win_set_cursor(_clang_c.vargs_win, { 1, #_clang_c.vargs_data })
        end
    })

    vim.api.nvim_buf_set_keymap(_clang_c.vargs_buf, "i", "<CR>", "", {
        noremap = true,
        callback = function()
            local current_line = vim.api.nvim_get_current_line()
            _clang_c.vargs_data = current_line
            vim.api.nvim_buf_set_lines(_clang_c.vargs_buf, 0, -1, false, { _clang_c.vargs_data })
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
            vim.api.nvim_set_current_win(_clang_c.win)
        end
    })


    local htop_win_width = 23
    local htop_win_height = 1
    local htop_win_x = math.floor((win_width - htop_win_width) / 2)
    local htop_win_y = math.floor((win_height - htop_win_height) / 2) - 5

    _clang_c.htop_buf = vim.api.nvim_create_buf(false, true)
    local htop_lines = _clang_c.use_htop and { "Profile with htop? " } or { "Profile with htop? 󰜺" }
    vim.api.nvim_buf_set_lines(_clang_c.htop_buf, 0, -1, false, htop_lines)

    _clang_c.htop_win = vim.api.nvim_open_win(_clang_c.htop_buf, true, {
        relative = "editor",
        width = htop_win_width,
        height = htop_win_height,
        row = htop_win_y,
        col = htop_win_x,
        style = "minimal",
        border = "single",
        focusable = false,
        zindex = 200,
    })

    vim.api.nvim_set_option_value("buftype", "nofile", { buf = _clang_c.htop_buf })
    vim.api.nvim_set_option_value("buflisted", false, { buf = _clang_c.htop_buf })

    local width, height = 23 , #_clang_c.options
    local win_x = math.floor((win_width - width) / 2)
    local win_y = math.floor((win_height - height) / 2)

    _clang_c.buf = vim.api.nvim_create_buf(false, true)
    local lines = {}
    for i, opt in ipairs(_clang_c.options) do
        table.insert(lines, i .. ". " .. opt)
    end
    vim.api.nvim_buf_set_lines(_clang_c.buf, 0, -1, false, lines)

    _clang_c.win = vim.api.nvim_open_win(_clang_c.buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = win_y,
        col = win_x,
        style = "minimal",
        title = "Build Options[1]",
        title_pos = "left",
        border = "single",
        zindex = 300,
    })

    local last_option_line = indexof(_clang_c.options, _clang_c.selected_option) or 1

    vim.api.nvim_win_set_cursor(_clang_c.win, { last_option_line , 0 })

    for i, key in ipairs(keys_bindings) do
        local delta = (i == 1) and 1 or -1
        for _, k in ipairs(key) do
            vim.api.nvim_buf_set_keymap(_clang_c.buf, "n", k, "", {
                noremap = true,
                callback = function()
                    local cur = vim.api.nvim_win_get_cursor(_clang_c.win)[1]
                    cur = cur + delta
                    if cur > #_clang_c.options  then cur = 1 end
                    if cur < 1 then cur = #_clang_c.options end
                    vim.api.nvim_win_set_cursor(_clang_c.win, { cur, 0 })
                end
            })
        end
    end



    vim.api.nvim_create_autocmd("WinClosed", {
        buffer = _clang_c.buf,
        callback = function()
            delete_if_valid(_clang_c.buf, _clang_c.win)
            delete_if_valid(_clang_c.vargs_buf, _clang_c.vargs_win)
            delete_if_valid(_clang_c.htop_buf, _clang_c.htop_win)
            _clang_c.vargs_can_focus = false
        end
    })

    vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
        local cur_win = vim.api.nvim_get_current_win()
        if cur_win == _clang_c.win then
            vim.schedule(function()
                local current_buf = nil
                if vim.api.nvim_win_is_valid(cur_win) then current_buf = vim.api.nvim_win_get_buf(cur_win) end
                if current_buf ~= _clang_c.buf then
                    if(vim.api.nvim_buf_is_valid(_clang_c.buf)) then vim.api.nvim_win_set_buf(cur_win, _clang_c.buf) end
                end
            end)
        end
    end
})


    vim.api.nvim_set_option_value("modifiable", false, { buf = _clang_c.buf })
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = _clang_c.buf })
    vim.api.nvim_set_option_value("buflisted", false, { buf = _clang_c.buf })

    _clang_c:select_option(nvim_dir, filename)


    vim.api.nvim_buf_set_keymap(_clang_c.buf, "n", "<Leader>ht", "", {
        noremap = true,
        callback = function()
            _clang_c.use_htop = not _clang_c.use_htop
            vim.api.nvim_buf_set_lines(_clang_c.htop_buf, 0, -1, false, { "Profile with htop? " .. (_clang_c.use_htop and "" or "󰜺") })
        end
    })

    --focus on vargs window
    vim.api.nvim_buf_set_keymap(_clang_c.buf, "n", "2", "", {
        noremap = true,
        callback = function()
            _clang_c.vargs_can_focus = not _clang_c.vargs_can_focus
            vim.api.nvim_set_current_win(_clang_c.vargs_win)
            vim.api.nvim_set_option_value("modifiable", true, { buf = _clang_c.vargs_buf })
        end
    })

    vim.api.nvim_buf_set_keymap(_clang_c.vargs_buf, "n", "1", "", {
        noremap = true,
        callback = function()
            vim.api.nvim_set_current_win(_clang_c.win)
            vim.api.nvim_set_option_value("modifiable", false, { buf = _clang_c.vargs_buf })
        end
    })

    vim.api.nvim_buf_set_keymap(_clang_c.buf, "n", "q", "", {
        noremap = true,
        callback = function()
            delete_if_valid(_clang_c.buf, _clang_c.win)
            delete_if_valid(_clang_c.vargs_buf, _clang_c.vargs_win)
            delete_if_valid(_clang_c.htop_buf, _clang_c.htop_win)
            _clang_c.vargs_can_focus = false
        end
    })

end


function _clang_c:select_option(nvim_dir, filename)
    vim.keymap.set("n", "<CR>", function()
        local current_cursor = vim.api.nvim_win_get_cursor(_clang_c.win)
        local line = current_cursor[1]

        local option = _clang_c.options[line] or "error"
        self:set_selected_option(option)

        delete_if_valid(_clang_c.htop_buf, _clang_c.htop_win)
        delete_if_valid(_clang_c.buf, _clang_c.win)
        delete_if_valid(_clang_c.vargs_buf, _clang_c.vargs_win)

        local formatted_cmd = string.format(
            "python3 %s/shellscripts/run_clanguage.py %s '%s' '%s'",
            nvim_dir,
            filename,
            option,
            _clang_c.vargs_data
        )

        local prev_win = vim.api.nvim_get_current_win()

        vim.api.nvim_set_current_win(prev_win)

        local term_buf = vim.api.nvim_create_buf(false, true)
        vim.cmd("botright split")
        local term_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_height(term_win, 20)
        vim.api.nvim_win_set_buf(term_win, term_buf)

        _clang_c.terminal_main_buf = term_buf
        _clang_c.terminal_main_win = term_win

        vim.fn.termopen(formatted_cmd, {
            buf = term_buf,
            on_exit = function()
                delete_if_valid(_clang_c.terminal_htop_buf, _clang_c.terminal_htop_win)
                delete_if_valid(_clang_c.vargs_buf, _clang_c.vargs_win)
            end
        })

        vim.api.nvim_set_option_value("buftype", "terminal", { buf = term_buf })
        vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = term_buf })
        vim.api.nvim_set_option_value("buflisted", false, { buf = term_buf })

        vim.api.nvim_set_current_win(prev_win)

        if _clang_c.use_htop then
            local build_file_path = vim.fn.getcwd() .. "/build.txt"
            local file = io.open(build_file_path, "r")

            if not file then
                Snacks.notify.error("Error opening file")
                return
            end

            local build_file_content = file:read("*a")
            local build_file_lines = vim.split(build_file_content, "\n")
            local exec_name = AfterPattern(build_file_lines[2] or "", "executable_name=")
            file:close()

            if exec_name == "" then
                Snacks.notify.error("Error reading file")
                return
            end

            local htop_buf = vim.api.nvim_create_buf(false, true)
            vim.cmd("botright vsplit")
            local htop_win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(htop_win, htop_buf)
            vim.api.nvim_win_set_width(htop_win, 85)

            _clang_c.terminal_htop_buf = htop_buf
            _clang_c.terminal_htop_win = htop_win

            vim.fn.termopen("htop --filter " .. exec_name, { buf = htop_buf })

            vim.api.nvim_set_option_value("buftype", "terminal", { buf = htop_buf })
            vim.api.nvim_set_option_value("bufhidden", "hide", { buf = htop_buf })
            vim.api.nvim_set_option_value("buflisted", false, { buf = htop_buf })
        end

        vim.api.nvim_set_current_win(prev_win)
    end, { buffer = _clang_c.buf })
end



return _clang_c
