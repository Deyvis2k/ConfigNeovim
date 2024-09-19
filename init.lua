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
  use 'windwp/nvim-autopairs'
  use 'loctvl842/monokai-pro.nvim'
  use 'tiagovla/tokyodark.nvim'
  use 'ellisonleao/gruvbox.nvim'


  --indent line
  use 'lukas-reineke/indent-blankline.nvim'

  --yazi
  use 'mikavilpas/yazi.nvim'

  -- Dashboard
  use {'mg979/vim-visual-multi', branch = 'master'}
   

  -- nvim tree 
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
      }
  }

  use {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      -- config
    }
  end,
  requires = {'nvim-tree/nvim-web-devicons'}
}

--toggleterm 
  use {
    "akinsho/toggleterm.nvim",
    tag = '*',
    config = function()
      require("toggleterm").setup()
   end
}

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

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  --vim airline
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'

  -- Git
  use 'tpope/vim-fugitive'

end)

-- Carregando configurações pessoais
require("preferences")
require("colors")
require("remap")
require("telescope")
require("treesitter")
require("lsp")
require("airline_config")
require("yazi")


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

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})
