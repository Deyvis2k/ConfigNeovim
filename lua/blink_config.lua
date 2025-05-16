return {
    {'saghen/blink.cmp', dependencies = {
    'rafamadriz/friendly-snippets',
    'moyiz/blink-emoji.nvim',
    'onsails/lspkind.nvim',
    },
    version = "1.*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            enabled = function()
                return not vim.tbl_contains({ "http" }, vim.bo.filetype)
                  and vim.bo.buftype ~= "prompt"
              end,
            keymap = {
                preset = "default",
                ["<CR>"] = { "accept", "fallback"},
            },
            appearance = {
                nerd_font_variant = "mono",
                use_nvim_cmp_as_default = true,

                kind_icons = {
                    Class = "󰠱",
                    Color = "󰏘",
                    Constant = "󰏿",
                    Constructor = "",
                    Enum = "",
                    EnumMember = "",
                    Event = "",
                    Field = "",
                    File = "󰈙",
                    Folder = "",
                    Function = "󰊕",
                    Interface = "",
                    Keyword = "󰌋",
                    Method = "󰆧",
                    Module = "󰏓",
                    Property = "",
                    Reference = "󰈇",
                    Snippet = "",
                    Struct = "󰙅",
                    Text = "󰉿",
                    TypeParameter = "󰅲",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Variable = "󰂡",
                }
            },

            completion = {
                documentation = {
                    auto_show = true,
                    treesitter_highlighting = true,
                    window = {
                        border = "single",
                        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
                menu = {
                    border = "rounded",
                    draw = {
                        columns = {
                            {"label", "label_description", gap = 3 }, { "kind_icon", "kind", gap = 1},
                        }
                    }
                },
            },

            signature = {enabled = true, window = {border = "rounded"}},


            sources = {
                default = { "lsp", "path", "snippets", "buffer", "emoji"},
                per_filetype = {
                    sql = {'snippets', 'dadbod', 'buffer'},
                },
                providers = {
                    dadbod = {
                        name = "Dadbod",
                        module = "vim_dadbod_completion.blink",
                    },
                    emoji = {
                        module = "blink-emoji",
                        name = "Emoji",
                        score_offset = 15,
                        opts = { insert = true },
                        should_show_items = function()
                            return vim.tbl_contains(
                                { "gitcommit", "markdown" },
                                vim.o.filetype
                            )
                        end,
                    },
                },
            },
            fuzzy = {implementation = "prefer_rust_with_warning"},
        },
        opts_extend = { "sources.default"},
    },
}
