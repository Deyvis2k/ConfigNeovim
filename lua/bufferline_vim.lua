require("bufferline").setup {
  options = {
    mode = "buffers",
    close_command = "bdelete! %d",
    right_mouse_command = "bdelete! %d",
    left_mouse_command = "buffer %d",
    -- separator_style = "slant",
    middle_mouse_command = nil,
    indicator = {
      icon = " ",
    },
    themable = true,
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    show_close_icon = false,
    always_show_bufferline = true,
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
    offsets = {
      {
        filetype = "NvimTree",
        text = function ()
            return vim.fn.getcwd()
        end,
        text_align = "center",
        highlight = "Directory",
        separator = true
      },
    },

    highlights = {
        fill = {bg = "none"}
    },
  },
}

