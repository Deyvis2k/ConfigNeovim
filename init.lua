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

require("mason").setup()
require("lspconfig_config")
require("preferences")
require("remap")
require("treesitter")
require("telescope_config")
require("astro")
require("debug_config")
require("bufferline_vim")
require("nvim-autopairs").setup()
require("nvim_autocmds_my")
require("autoloading_settings")
require("auto-session").setup({})

vim.lsp.config["lua_ls"] = {
  cmd = { "lua-language-server"},
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim", "require", "use", "setup" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
}


vim.lsp.enable("lua_ls")


require('nvim-treesitter.configs').setup {
  ensure_installed = { "xml", ... },
  highlight = { enable = true },
  -- ...
}

vim.treesitter.language.register('xml', 'axaml')
