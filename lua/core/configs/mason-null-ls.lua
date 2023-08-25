require("mason-null-ls").setup({
    ensure_installed = {
        -- Opt to list sources here, when available in mason.
    },
    automatic_installation = false,
    handlers = {},
})
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- Anything not supported by mason.
        --null_ls.builtins.diagnostics.ltrs,
        null_ls.builtins.formatting.clang_format,
    }
})
