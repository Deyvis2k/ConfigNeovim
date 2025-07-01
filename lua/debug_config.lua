local dap = require('dap')
local username = os.getenv("USER")
dap.adapters.coreclr = {
  type = 'executable',
  command = '/home/' .. username .. '/.local/share/nvim/mason/packages/netcoredbg/libexec/netcoredbg/netcoredbg',
  args = { '--interpreter=vscode' },
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end
  },
}

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-dap',
  name = 'lldb'
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}

require('dapui').setup()

-- Auto abrir/fechar o UI com eventos do DAP
dap.listeners.after.event_initialized['dapui_config'] = function()
  require("dapui").open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  require("dapui").close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  require("dapui").close()
end

-- Definir a cor para os breakpoints
vim.api.nvim_set_hl(0, 'DapBreakpoint', {bold = true, fg = '#FF0000'}) --red
vim.api.nvim_set_hl(0, 'DapBreakpointCondition', {bold = true, fg = '#FF8800'}) --orange
vim.api.nvim_set_hl(0, 'DapStopped', {bold = true, fg = '#00FF00'}) -- green

-- Configuração dos sinais do DAP
vim.fn.sign_define('DapBreakpoint', {text = '', texthl = 'DapBreakpoint', linehl = '', numhl = ''})
vim.fn.sign_define('DapBreakpointCondition', {text = '', texthl = 'DapBreakpointCondition', linehl = '', numhl = ''})
vim.fn.sign_define('DapStopped', {text = '➜', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = ''})
