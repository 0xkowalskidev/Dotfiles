local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
        -- Setup format on save
        vim.api.nvim_create_autocmd('BufWritePre', {
                callback = function()
                        vim.lsp.buf.format({ async = false })
                end,
        })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Lua
lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities
})

-- Go
lspconfig.gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities
})

-- Html
lspconfig.html.setup({
        on_attach = on_attach,
        capabilities = capabilities
})

-- Css
lspconfig.cssls.setup({
        on_attach = on_attach,
        capabilities = capabilities
})

-- Json
lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = capabilities
})

-- Nix
lspconfig.nixd.setup({
        on_attach = on_attach,
        capabilities = capabilities
})
