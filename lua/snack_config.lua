return {
    explorer = {
        replace_netrw = true
    },
    terminal = {

    },
    lazygit = {

    },
    animate = {
      ---@type snacks.animate.Duration|number
      duration = 20,
      easing = "linear",
      fps = 60,
    },
    notifier = {
        timeout = 8000,
        width = { min = 40, max = 0.4 },
        height = { min = 2, max = 0.6 },
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
        style = "fancy",
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
    },
    styles = {
        notification = {
            border = "rounded",
            zindex = 100,
            ft = "markdown",
            wo = {
                winblend = 5,
                wrap = false,
                conceallevel = 2,
                colorcolumn = "",
            },
            bo = { filetype = "snacks_notif" },
        }
    }
}
