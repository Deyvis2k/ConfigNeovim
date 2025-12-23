local capabilities = require("nvchadlsp").capabilities
local on_attach = require("nvchadlsp").on_attach

local util = require("lspconfig").util

local function setup_lspserver(lspserver_name, capabilities, on_attach, ...)
    vim.lsp.config[lspserver_name] = {
        on_attach = on_attach,
        capabilities = capabilities,
        ...
    }
    vim.lsp.enable(lspserver_name)
end

setup_lspserver("cssls", capabilities, on_attach)
-- setup_lspserver("pyright", capabilities, on_attach, require("pyright_config"))

setup_lspserver("rust_analyzer", capabilities, on_attach, {
    cmd = { "rust-analyzer" },
    filetypes = { "rust", "rs" },
    root_dir = util.root_pattern("Cargo.toml"),
    -- settings = {
    --     ["rust-analyzer"] = {
    --         cargo = { allFeatures = true, loadOutDirsFromCheck = true },
    --         procMacro = { enable = true },
    --     },
    -- },
})

setup_lspserver("clangd", capabilities, on_attach, {
    cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
    filetypes = { "c", "cpp", "h", "hpp" }
})


setup_lspserver("omnisharp", capabilities, on_attach, {
    cmd = { "omnisharp" },
    filetypes = { "cs" },
    settings = {
        FormattingOptions = {
            EnableEditorConfigSupport = true,
        }
    }
})

require('lazydocker').setup({
  window = {
    settings = {
      width = 0.818,
      height = 0.818,
      border = 'rounded',
      relative = 'editor',
    },
  },
})


-- vim.lsp.config["ts_ls"] = {
--   on_attach = on_attach,
--   capabilities = capabilities,
--     default_config = {
--     init_options = { hostInfo = 'neovim' },
--     cmd = { 'typescript-language-server', '--stdio' },
--     filetypes = {
--       'javascript',
--       'javascriptreact',
--       'javascript.jsx',
--       'typescript',
--       'typescriptreact',
--       'typescript.tsx',
--     },
--     root_dir = util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git'),
--     single_file_support = true,
--   },
-- }

setup_lspserver("ts_ls", capabilities, on_attach, {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
    single_file_support = true
})


setup_lspserver("harper_ls", capabilities, on_attach, {
    filetypes = { "rb" },
    root_dir = util.root_pattern("harper.json"),
    settings = {},
})

setup_lspserver("ols", capabilities, on_attach, {
    cmd = { "ols" },
    filetypes = { "odin" }
})

setup_lspserver("blueprint_ls", capabilities, on_attach, {
    cmd = { "blueprint-compiler", "lsp" },
    filetypes = { "blueprint" },
    -- root_dir = util.root_pattern(".git", "meson.build"),
    settings = {}
})

setup_lspserver("vala_ls", capabilities, on_attach, {
    filetypes = { "vala", "genie" },
    cmd = { "vala-language-server" },
    root_dir = util.root_pattern(".git", "meson.build"),
    single_file_support = true
})


setup_lspserver("pylsp", capabilities, on_attach, {
    plugins = {
        pycodestyle = {
            enabled = false
        },
        flake8 = {
            enabled = false
        },
        black = {
            enabled = false, line_length = 88
        },
        ruff = {
            enabled = true, formatEnabled = true
        }

    }
})

vim.lsp.enable("qmlls")
