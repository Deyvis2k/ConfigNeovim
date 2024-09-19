if vim.g.arline_symbols == nil then
  arline_symbols = {}
  arline_symbols.mode = ''
  arline_symbols.maxlinenr = ''
  arline_symbols.branch = ''
  arline_symbols.linenr = ''
  arline_symbols.colnr = ''
  arline_symbols.filename = ''
  vim.g.arline_symbols = arline_symbols
end

function get_icon()
    local filename = vim.fn.expand('%:t')
    local file_ext = vim.fn.expand('%:e')
    local icon, _ = require('nvim-web-devicons').get_icon(filename, file_ext, { default = true })
    return icon or ''
end

local function update_icon()
    vim.g.arline_symbols.filename = get_icon()
end

vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
          update_icon()
    end,
  })

function MyAirlineMode()
    local mode_map = {
    	n = "NORMAL",
    	i = "INSERT",
    	v = "VISUAL",
   	    V = "V-LINE",
   	    [''] = "V-BLOCK",
   	    c = "COMMAND",
    	r = "REPLACE",
    }
    local current_mode = vim.fn.mode()
    return (mode_map[current_mode] or current_mode) .. ' ' .. vim.g.arline_symbols.mode
end

--configurações vim airline
vim.g["airline_theme"] = 'wombat'
vim.g["airline_powerline_fonts"] = 1
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#whitespace#enabled"] = 0


-- Configurar os símbolos do vim-airline
vim.g.airline_section_a = "%{v:lua.MyAirlineMode()}"
vim.g.airline_section_c = "%{v:lua.get_icon()} %t" 
vim.g.airline_section_x = ''
vim.g.airline_section_y = ''
vim.g.airline_section_z = ''
vim.g.airline_skip_empty_sections = 1
