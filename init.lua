local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    require("dependencies")
})


local capabilities = require("nvchadlsp").capabilities
local on_attach = require("nvchadlsp").on_attach

local lspconfig = require("lspconfig")

require("mason-lspconfig").setup({
  function(server_name)
    lspconfig[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities
        })
  end,
})


require("mason").setup()
require("preferences")
require("remap")
require("telescope")
require("treesitter")
require("astro")
require("themeryconfig")
require("debug_config")
require("bufferline_vim")


require("nvim-autopairs").setup()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local util = lspconfig.util

lspconfig.cssls.setup { capabilities = capabilities }

lspconfig.pyright.setup(require("pyright_config"))

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "rust" },
  root_dir = util.root_pattern("Cargo.toml"),
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true, loadOutDirsFromCheck = true },
      procMacro = { enable = true },
    },
  },
})


lspconfig.omnisharp.setup({
  cmd = { "/home/deyvis/.local/share/nvim/mason/bin/OmniSharp" }, 
  on_attach = require("nvchadlsp").on_attach,
  capabilities = require("nvchadlsp").capabilities,
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      
    }
  }
})



lspconfig.clangd.setup({
    on_attach=on_attach,
    capabilities=capabilities,
    filetypes= {"c", "cpp", "h", "hpp"}
})

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim", "require", "use", "setup" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})

