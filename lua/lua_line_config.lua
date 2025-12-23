return {
  config = function(_, _)
    local config = {
      options = {
        component_separators = "",
        section_separators = --[[ { left = "◤", right = "|" } ]] "",
        theme = "iceberg_dark",
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "lazy", "alpha", "snacks_dashboard", "terminal", "NvimTree"},
          winbar = { "lazy", "alpha", "snacks_dashboard", "terminal", "NvimTree" },
        },
      },
      sections = {
        lualine_a = {
          { "mode", separator = { right="" } },
        },
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    }

    local function insert_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    local function insert_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    insert_left({
      "branch",
      icon = "",
      color = { fg = "#ebdbb2", gui = "bold" },
    })

    insert_left({
      "diff",
      symbols = { added = " ", modified = " ", removed = " " },
      diff_color = {
        added = { fg = "#b8bb26" },
        modified = { fg = "#fabd2f" },
        removed = { fg = "#fb4934" },
      }
    })

    insert_left({
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = { error = " ", warn = " ", info = " " },
    })

    insert_left({
      function()
        return "%="
      end,
    })
    insert_right({ "location" })
    insert_right({ "lsp_status" })
    insert_right(Snacks.profiler.status())
    insert_right({
      function()
        return require("noice").api.status.command.get()
      end,
      cond = function()
        return package.loaded["noice"] and require("noice").api.status.command.has()
      end,
      color = function()
        return { fg = Snacks.util.color("Statement") }
      end,
    })

    insert_right({
        function() return require("noice").api.status.mode.get() end,
      cond = function()
        return package.loaded["noice"] and require("noice").api.status.mode.has()
      end,
      color = function()
        return { fg = Snacks.util.color("Constant") }
      end,
    })

    insert_right({
        function() return "  " .. require("dap").status() end,
      cond = function()
        return package.loaded["dap"] and require("dap").status() ~= ""
      end,
      color = function()
        return { fg = Snacks.util.color("Debug") }
      end,
    })

      insert_right({
        require("lazy.status").updates,
        cond = require("lazy.status").has_updates,
        color = function() return { fg = Snacks.util.color("Special") } end,
      })

    insert_right({
      function()
        return "|"
      end,
      color = { fg = "#9c9c9c" },
      padding = { right = 0 },
    })
    insert_right({
      function()
        local filename = vim.fn.expand("%:t")
        local extension = vim.fn.expand("%:e")
        local filename_only = string.sub(filename, 1, #filename - #extension - 1) if extension == "" then filename_only = filename end
        return filename_only
      end,
      color = { fg = "#adadad", gui = "bold" },
    })
    insert_right({"filetype", icon_only = true, padding = { right = 0 }})

    insert_right({
      function()
         if vim.bo.modified then return "|" else return "" end
      end,
      color = { fg = "#9c9c9c" },
      padding = { right = 0 },
    })

    insert_right({
      function()
        local actual_win_name = vim.fn.expand("%:t")
         if (vim.bo.modified and actual_win_name ~= "" or not actual_win_name) then return "●" else return "" end
      end,
      color = { fg = "#adadad", gui = "bold" },
    })


    require("lualine").setup(config)
  end,
}
