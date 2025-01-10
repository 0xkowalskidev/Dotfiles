local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
        -- Setup format on save
        vim.api.nvim_create_autocmd('BufWritePre', {
                buffer = bufnr,
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

-- Odin
lspconfig.ols.setup({
        on_attach = on_attach,
        capabilities = capabilities
})


-- Templ
lspconfig.templ.setup({
        on_attach = on_attach,
        capabilities = capabilities
})

-- Htmx
lspconfig.htmx.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "html", "templ" },
})

-- Tailwind
lspconfig.tailwindcss.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "templ", "astro", "javascript", "typescript", "react" },
        settings = {
                tailwindCSS = {
                        includeLanguages = {
                                templ = "html",
                        },
                },
        },
})

-- Html
lspconfig.html.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "html", "templ" },
})

-- Css
lspconfig.cssls.setup({
        on_attach = on_attach,
        capabilities = capabilities
})

-- JS
lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
})

-- Json
lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = capabilities
})

-- Nix
lspconfig.nil_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
                ['nil'] = {
                        formatting = {
                                command = { "nixpkgs-fmt" },
                        },
                },
        },
})
