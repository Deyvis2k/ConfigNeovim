local Terminal = require("toggleterm.terminal").Terminal

local current_dir = vim.fn.getcwd()

local function build_java()
        local width, height = 30, 5
        local win_width = vim.o.columns
        local win_height = vim.o.lines
        local win_x = math.floor((win_width - width) / 2)
        local win_y = math.floor((win_height - height) / 2)

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Selecione uma opção:", "1. node run", "2. Build", "3. Detailed Build", "Pressione 'q' para sair"})

        local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            row = win_y,
            col = win_x,
            style = "minimal",
            border = "rounded",
            title = "Build Options",
            title_pos = "center"
        })

        vim.api.nvim_buf_set_keymap(buf, "n", "1", "", {
            noremap = true,
            callback = function()
                vim.api.nvim_win_close(win, true)
                Terminal:new({
                    cmd = "cd " .. current_dir .. " && ./gradlew build",
                    direction = "float",
                    close_on_exit = false,
                    hidden = false
                }):toggle()
            end
        })

        vim.api.nvim_buf_set_keymap(buf, "n", "2", "", {
            noremap = true,
            callback = function()
                vim.api.nvim_win_close(win, true)
                Terminal:new({
                    cmd = "cd " .. current_dir .. " && ./gradlew bootRun",
                    direction = "float",
                    close_on_exit = false,
                    hidden = false
                }):toggle()
            end
        })

        vim.api.nvim_buf_set_keymap(buf, "n", "3", "", {
            noremap = true,
            callback = function()
                vim.api.nvim_win_close(win, true)
                Terminal:new({
                    cmd = "cd " .. current_dir .. " && ./gradlew build --scan",
                    direction = "float",
                    close_on_exit = false,
                    hidden = false
                }):toggle()
            end
        })

        vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
            noremap = true,
            callback = function()
                vim.api.nvim_win_close(win, true)
            end
        })
end




