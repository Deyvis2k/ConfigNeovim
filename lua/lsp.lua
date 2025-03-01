local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
    window = {
      completion = cmp.config.window.bordered({
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
              border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
            }),
      documentation = cmp.config.window.bordered({
              winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
              border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
            }),
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "...",
    }),
  },
})
local lspkind = require('lspkind')
local luasnip = require('luasnip')

require('mason').setup({
    ui = {
        border = 'rounded'
    },
})
require("mason-lspconfig").setup({
  ensure_installed = { "omnisharp", "lua_ls" , "pyright", "clangd", "cssls" },
})


vim.diagnostic.config({
    float = {
        border = "rounded",
    }
})

require("lspconfig.ui.windows").default_options.border = "rounded"

cmp.setup({
    -- Habilitar/desabilitar o cmp baseado em clientes LSP ativos
    enabled = function()
        local clients = vim.lsp.get_active_clients()
        return #clients > 0 -- Só habilita se houver LSP ativo
    end,

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    completion = {
        completeopt = "menu,noselect",
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-c>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),

    sources = cmp.config.sources({
        {
            name = "nvim_lsp",
            entry_filter = function(entry, ctx)
                return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
            end,
        },
        {
            name = "luasnip",
        },
        {
            name = "path",
        },
        {
            name = "buffer",
        }
    }),

    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
        }),
    },

    experimental = {
        ghost_text = true,
    },
})

