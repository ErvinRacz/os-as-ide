local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')
local lspkind = require('lspkind')

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
    'bashls',
    'lua_ls',
    'tsserver',
    'eslint',
    'jsonls',
    'yamlls',
    'tailwindcss',
    'html',
    'cssls',
    'jdtls',
})

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    },
}

lspconfig.ocamllsp.setup {
    cmd = { "ocamllsp" },
    filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
    root_dir = lspconfig.util.root_pattern("*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace"),
    capabilities = capabilities,
}

-- bash, requires bash-language-server
lspconfig.bashls.setup {
    flags = lsp_flags,
}

lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    'require'
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("lua", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

lspconfig.tsserver.setup({})

lspconfig.cssls.setup {
    capabilities = capabilities,
    flags = lsp_flags,
}
lspconfig.html.setup {
    capabilities = capabilities,
    flags = lsp_flags,
}
-- json
lspconfig.jsonls.setup {
    capabilities = capabilities,
    flags = lsp_flags,
}
-- yaml
lspconfig.yamlls.setup {
    capabilities = capabilities,
    flags = lsp_flags,
    settings = {
        yaml = {
            format = {
                enable = true,
            },
            hover = true,
            completion = true,

            customTags = {
                "!fn",
                "!And",
                "!If",
                "!Not",
                "!Equals",
                "!Or",
                "!FindInMap sequence",
                "!Base64",
                "!Cidr",
                "!Ref",
                "!Ref Scalar",
                "!Sub",
                "!GetAtt",
                "!GetAZs",
                "!ImportValue",
                "!Select",
                "!Split",
                "!Join sequence"
            },
            schemas = {
                ["https://raw.githubusercontent.com/aws/serverless-application-model/main/samtranslator/schema/schema.json"] = "*template*.{yaml,yml}",
                -- ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
                --     "ci/*.yml", ".gitlab-ci.yml" },
            },
        },
    }
}
-- css+
lspconfig.tailwindcss.setup {
    flags = lsp_flags,
}
-- java
-- lspconfig.jdtls.setup {
-- flags = lsp_flags,
-- }

-- rust, requires rust_analyzer
-- lspconfig.rust_analyzer.setup {
-- 	on_attach = on_attach,
-- 	flags = lsp_flags,
-- }

local cmp = require('cmp')

-- cmp_autopairs required for inserint a pair of paranthesis automatically when completing a function or method
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

local cmp_select = { behavior = cmp.SelectBehavior.Select }
-- vim.api.nvim_set_keymap("i", "<C-l>", '<Plug>(copilot-next)', { silent = true })
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
    ['<Tab>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false
    }),
    ['<cr>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false
    }),
    ["<C-Space>"] = function(args)
        cmp.mapping.complete()
    end,
})

cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    preselect = 'none',
    mapping = cmp_mappings,
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'vsnip' },
    },
    snippet = {
        expand = function(args)
            -- Comes from vsnip
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',  -- show only symbol annotations
            maxwidth = 70,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        })
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<C-q>", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<space>td", function() vim.lsp.buf.type_definition() end, opts)
    vim.keymap.set("i", "<C-q>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<a-e>", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "<a-E>", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set({ "n", "v", "i" }, "<a-cr>", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end, opts)
end)

lsp.skip_server_setup({ 'jdtls' })
lsp.setup()

--#region For formatting with external tools we need to itnerface a plugin
local filtetypes_from_lsp_for_prettier = {
    'eslint',
    'tsserver',
    'html',
    'cssls',
    'jsonls',
    'yamlls'
    -- Add more servers here
}

local function format_with_prettierd()
    return {
        exe = "prettierd",
        args = { vim.api.nvim_buf_get_name(0) },
        stdin = true
    }
end

-- Function to get the list of filetypes for each LSP server
local function map_prettierd_to_filetypes(servers, additiona_filetypes)
    local filetypes = {}

    for _, server in ipairs(servers) do
        local config = require("lspconfig")[server]
        if config and config.filetypes then
            for _, ft in ipairs(config.filetypes) do
                filetypes[ft] = { format_with_prettierd }
            end
        end
    end

    if additiona_filetypes then
        for _, ft in ipairs(additiona_filetypes) do
            filetypes[ft] = { format_with_prettierd }
        end
    end

    return filetypes
end

local prettierd_filetype_mappings = map_prettierd_to_filetypes(filtetypes_from_lsp_for_prettier, { 'markdown', 'mdx' })
require('formatter').setup({
    -- Enable or disable logging
    logging = false,
    -- Set the log level
    -- log_level = vim.log.levels.DEBUG,
    filetype = vim.tbl_extend('keep', prettierd_filetype_mappings, {
        ocaml = {
            function()
                local util = require "formatter.util"
                return {
                    exe = "ocamlformat",
                    args = {
                        "--enable-outside-detected-project",
                        util.escape_path(util.get_current_buffer_file_path()),
                    },
                    stdin = true,
                }
            end
        },
        sh = {
            require("formatter.filetypes.sh").shfmt,
        },
        ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
            function()
                -- Ignore already configured types.
                local defined_types = require("formatter.config").values.filetype
                if defined_types[vim.bo.filetype] ~= nil then
                    return nil
                end
                vim.lsp.buf.format({ async = true })
            end,
        },
        -- Add more filetypes here
    }),
})
--#endregion
