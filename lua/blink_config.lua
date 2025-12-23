local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

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
              ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
              ["<Up>"] = { "select_prev", "fallback" },
              ["<Down>"] = { "select_next", "fallback" },
              ["<C-N>"] = { "select_next", "show" },
              ["<C-P>"] = { "select_prev", "show" },
              ["<C-J>"] = { "select_next", "fallback" },
              ["<C-K>"] = { "select_prev", "fallback" },
              ["<C-U>"] = { "scroll_documentation_up", "fallback" },
              ["<C-D>"] = { "scroll_documentation_down", "fallback" },
              ["<C-e>"] = { "hide", "fallback" },
              ["<CR>"] = { "accept", "fallback" },
              ["<Tab>"] = {
                "select_next",
                "snippet_forward",
                function(cmp)
                  if has_words_before() or vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
                end,
                "fallback",
              },
              ["<S-Tab>"] = {
                "select_prev",
                "snippet_backward",
                function(cmp)
                  if vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
                end,
                "fallback",
              },
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
