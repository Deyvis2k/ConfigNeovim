return {
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
}
