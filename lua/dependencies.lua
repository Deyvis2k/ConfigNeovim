
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
    {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = require("snack_config")
    },
    { "tpope/vim-dadbod" },
    { "kristijanhusak/vim-dadbod-ui"},
    { "kristijanhusak/vim-dadbod-completion" },
    {"thetek42/vim-blueprint-syntax"},

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
    'crnvl96/lazydocker.nvim',
    opts = {},
    },

    {
    "Exafunction/codeium.vim",
    config = function()
      vim.keymap.set("i", "<M-c>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true }) --alt
      vim.keymap.set("i", "<C-;>", function() return vim.fn end, { expr = true, silent = true })
      vim.keymap.set("i", "<C-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, silent = true })
      vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })
    end,
    },
    {
    "MonsieurTib/neonuget",
    config = function()
    require("neonuget").setup({
      dotnet_path = "dotnet",
      default_project = nil,
    })
    end,
    dependencies = {
    "nvim-lua/plenary.nvim",
    }
    },

    {
    "wnkz/monoglow.nvim",
    lazy  = false,
    priority = 1000,
    opts = {},
    },

    {
        "mistweaverco/kulala.nvim",
        keys = {
            { "<leader>Rs", desc = "Send request" },
            { "<leader>Ra", desc = "Send all requests" },
            { "<leader>Rb", desc = "Open scratchpad" },
        },
        ft = {"http", "rest"},
        opts = {
            global_keymaps = true,
        },
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
        config = function()
          require("telescope").setup({
                pickers = {
                    colorscheme = {
                        enable_preview = true,
                    },
                }
            })
        end,
    },
    {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    },

    { "tpope/vim-fugitive" },
    {
    "akinsho/bufferline.nvim",
    version = "*",
    {"nvim-tree/nvim-web-devicons"},
    },

    {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    },

    {
    "nvim-lualine/lualine.nvim",
        opts = {
            options = {},
    },
        config = require("lua_line_config").config,
    },

    {
      "rmagatti/auto-session",
      lazy = false,

      opts = {
        suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        -- log_level = 'debug',
      },
    },

    require("themes_config"),
}
