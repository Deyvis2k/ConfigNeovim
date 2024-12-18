vim.cmd [[packadd packer.nvim]]


-- Packer startup function
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'theprimeagen/harpoon'
  use {'neoclide/coc.nvim', branch = 'release'}
  use 'folke/tokyonight.nvim'
  use 'rose-pine/neovim'
  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'}
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/nvim-cmp'}
  use {'L3MON4D3/LuaSnip'}
  use 'sainnhe/sonokai'
  use 'Mofiqul/dracula.nvim'
  use 'loctvl842/monokai-pro.nvim'
  use 'windwp/nvim-autopairs'
  use 'tiagovla/tokyodark.nvim'
  use 'ellisonleao/gruvbox.nvim'
  use 'shaunsingh/nord.nvim'
  use 'olimorris/onedarkpro.nvim'

  --indent line
  use 'lukas-reineke/indent-blankline.nvim'

  -- Dashboard
  use {'mg979/vim-visual-multi', branch = 'master'}

  -- nvim tree 
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
      }
  }

  --toggleterm 
  use {
    "akinsho/toggleterm.nvim",
    tag = '*',
    config = function()
      require("toggleterm").setup()
   end
  }

  use { 'folke/snacks.nvim' }

  -- Codeium
  use {
    'Exafunction/codeium.vim',
    config = function ()
      vim.keymap.set('i', '<C-TAB>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
    
  -- Bufferline
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  --themery
  use 'zaldih/themery.nvim'

  -- Git
  use 'tpope/vim-fugitive'
end)

-- Carregando configurações pessoais
require("preferences")
require("remap")
require("telescope")
require("treesitter")
require("themeryconfig")
require("lsp")
require("bufferline_vim")
require("nordscheme")

-- Configurações do Mason
require('mason').setup()
require("mason-lspconfig").setup({
  ensure_installed = { "omnisharp" },
})



-- Configurações do LSP
local lspconfig = require("lspconfig")
require("mason-lspconfig").setup_handlers({
  function (server_name)
    lspconfig[server_name].setup {}
  end,
})


require('nvim-autopairs').setup{}

-- desativando o netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('onedarkpro').setup({
    styles = {
        types = "bold",
        methods = "bold",
        numbers = "bold",
        strings = "bold",
        comments = "bold",
        keywords = "bold",
        constants = "bold",
        functions = "bold",
        operators = "bold",
        variables = "bold",
        parameters = "bold",
        conditionals = "bold",
        virtual_text = "bold",
  }
})


-- nvim tree
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 40,
  },
  renderer = {
    group_empty = false,
    add_trailing = true,
    highlight_git = true,
    highlight_opened_files = "none",
    indent_markers = {
      enable = true,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        none = " ",
      },
    },
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
})


lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {
          'vim',
          'require',
          'use'
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
