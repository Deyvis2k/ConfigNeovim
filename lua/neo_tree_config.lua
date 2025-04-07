return {
    -- "nvim-tree/nvim-tree.lua",
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    -- config = function()
    --   require("nvim-tree").setup({
    --     sort = { sorter = "case_sensitive" },
    --     view = { width = 40 },
    --     renderer = {
    --       group_empty = false,
    --       add_trailing = true,
    --       highlight_git = true,
    --       highlight_opened_files = "none",
    --       indent_markers = { enable = true, inline_arrows = true },
    --     },
    --     filters = { dotfiles = false },
    --     git = { enable = true, ignore = false, timeout = 500 },
    --   })
    -- end,
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
      },
      lazy = false, -- neo-tree will lazily load itself
      ---@module "neo-tree"
      ---@type neotree.Config?
      opts = {
        -- fill any relevant options here
      },
}
