
return {
  { "neovim/nvim-lspconfig" },
  { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  { "theprimeagen/harpoon" },
  { "windwp/nvim-autopairs", config = true },
  { "onsails/lspkind.nvim" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "mg979/vim-visual-multi", branch = "master" },
  { "folke/snacks.nvim" },
  { "tpope/vim-dadbod" },
  { "kristijanhusak/vim-dadbod-ui"},
  { "kristijanhusak/vim-dadbod-completion" },

  require("neo_tree_config"),
  require("blink_config"),

   {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
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

  --lazygit
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  { "tpope/vim-fugitive" },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
  },

  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },



  require("themes_config"),
}
