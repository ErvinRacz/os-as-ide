local lsp = require('lsp-zero')

-- Custom file types
vim.filetype.add({
    extension = {
        eslintrc = "json",
        mdx = "markdown",
        prettierrc = "json",
        mjml = "html",
    },
    pattern = {
        [".*%.env.*"] = "sh",
    },
})

lsp.preset('recommended')

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'tailwindcss',
    'html',
    'cssls',
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<cr>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "<C-q>", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<a-e>", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<a-E>", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set({"n", "v", "i"}, "<a-cr>", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)

end)

lsp.setup()
