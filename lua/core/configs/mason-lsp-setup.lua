require("mason").setup({
    ensure_installed = {
        "debugpy",
        "clang-format"
    },
})
require("mason-lspconfig").setup {
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "pyright",
        "sqlls",
        "bashls",
        "cssls",
        "html",
        "clangd",
    },
}

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', require('fzf-lua').lsp_document_diagnostics, opts)

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD',require('fzf-lua').lsp_declarations, bufopts)
    vim.keymap.set('n', 'gs',require('fzf-lua').lsp_document_symbols, bufopts)
    vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', require('fzf-lua').lsp_implementations, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    --vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

    vim.keymap.set("n", "<leader>ca", require('fzf-lua').lsp_code_actions, bufopts)

    vim.keymap.set("n", "gr", require('fzf-lua').lsp_references, bufopts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lspconfig").lua_ls.setup {
    on_attach = on_attach,
    capabilitites = capabilities
}

require("lspconfig").pyright.setup {
    on_attach = on_attach,
    capabilitites = capabilities
}
require("lspconfig").rust_analyzer.setup {
    on_attach = on_attach,
    capabilitites = capabilities
}

require("lspconfig").clangd.setup {
    on_attach = on_attach,
    capabilitites = capabilities
}
