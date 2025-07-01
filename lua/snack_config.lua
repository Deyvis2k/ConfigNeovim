return {
    explorer = {
        replace_netrw = true
    },
    terminal = {

    },
    lazygit = {

    },
    notifier = {
        timeout = 8000,
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true,
        sort = { "level", "added" },
        level = vim.log.levels.TRACE,
        icons = {
            error = " ",
            warn = " ",
            info = " ",
            debug = " ",
            trace = " ",
        },
        keep = function(notif)
            return vim.fn.getcmdpos() > 0
        end,
        ---@type snacks.notifier.style
        style = "compact",
        top_down = true,
        date_format = "%R",
        ---@type string|boolean
        more_format = " ↓ %d lines ",
        refresh = 50,
    },
    picker = {
        ignored = true,
        sources = {
            files = {
                igonored = true,
                finder = "files"
            },
            explorer = {
                finder = "explorer"
            }
        }
    }
}
