require('bufferline').setup {
  options = {
    mode = "buffers", -- Modo: "buffers" para buffers ou "tabs" para abas
    numbers = "ordinal", -- Exibir números nos buffers
    close_command = "bdelete! %d", -- Comando para fechar buffer
    right_mouse_command = "bdelete! %d", -- Fechar com clique direito
    left_mouse_command = "buffer %d", -- Alternar buffer com clique esquerdo
    middle_mouse_command = nil, -- Nada para clique do meio

    indicator = {
      icon = '',
      style = 'underline'
    },
    buffer_close_icon = '', -- Ícone de fechar buffer
    modified_icon = '●', -- Ícone de modificação
    close_icon = '', -- Ícone para fechar bufferline inteira
    left_trunc_marker = '', -- Marcador de truncamento à esquerda
    right_trunc_marker = '', -- Marcador de truncamento à direita
    show_close_icon = false, -- Exibir o botão de fechar no final
    always_show_bufferline = true, -- Sempre mostrar bufferline
    diagnostics = "nvim_lsp", -- Mostra ícones de diagnósticos
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "center",
        highlight = "Directory",
        separator = true
      },
    },

    highlights = {
        buffer_selected = {
            fg = "#ff0000",
            underline = true,
            bold = true
        },
        offset_separator = {
                fg = "#ff0000",
                bg = "#ff0000"
        },
    },
  },
}

