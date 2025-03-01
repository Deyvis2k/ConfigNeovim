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
  { "neovim/nvim-lspconfig" },
  { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/nvim-cmp" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  { "theprimeagen/harpoon" },
  { "windwp/nvim-autopairs", config = true },
  { "onsails/lspkind.nvim" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "mg979/vim-visual-multi", branch = "master" },
  { "folke/snacks.nvim" },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort = { sorter = "case_sensitive" },
        view = { width = 40 },
        renderer = {
          group_empty = false,
          add_trailing = true,
          highlight_git = true,
          highlight_opened_files = "none",
          indent_markers = { enable = true, inline_arrows = true },
        },
        filters = { dotfiles = false },
        git = { enable = true, ignore = false, timeout = 500 },
      })
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup()
    end,
  },

  {
    "Exafunction/codeium.vim",
    config = function()
      vim.keymap.set("i", "<C-TAB>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-;>", function() return vim.fn end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  { "tpope/vim-fugitive" },

  { "rose-pine/neovim" },
  { "sainnhe/sonokai" },
  { "Mofiqul/dracula.nvim" },
  { "loctvl842/monokai-pro.nvim" },
  { "tiagovla/tokyodark.nvim" },
  { "AstroNvim/astrotheme" },
  { "folke/tokyonight.nvim" },
  { "olimorris/onedarkpro.nvim" },
  { "zaldih/themery.nvim" },

  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },
})

require("lsp")
require("preferences")
require("remap")
require("telescope")
require("treesitter")
require("astro")
require("themeryconfig")
require("debug_config")
--not used anymore
-- require ("bufferline_vim")

local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({})
  end,
})

require("nvim-autopairs").setup()


vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local capabilities = require("nvchadlsp").capabilities
local util = lspconfig.util
local on_attach = require("nvchadlsp").on_attach

lspconfig.cssls.setup { capabilities = capabilities }

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

