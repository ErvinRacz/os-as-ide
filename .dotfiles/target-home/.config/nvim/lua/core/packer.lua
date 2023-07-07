-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use('nvim-tree/nvim-web-devicons')
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or                            , branch = '0.1.x',
        requires = {
            { 'nvim-lua/plenary.nvim' },
        }
    }
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        }
    }
    use { 'stevearc/dressing.nvim' }
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('windwp/nvim-autopairs') -- to auto insert closinng pairs
    use('windwp/nvim-ts-autotag') -- to rename HTML tags
    use('JoosepAlviste/nvim-ts-context-commentstring') -- special line commenter for JSX, TSX
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({
                toggler = {
                    ---Line-comment toggle keymap
                    line = '<c-_>',
                    ---Block-comment toggle keymap
                    block = '<c-\\>',
                },
                opleader = {
                    ---Line-comment toggle keymap
                    line = '<c-_>',
                    ---Block-comment toggle keymap
                    block = '<c-\\>',
                },
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
        end
    }
    use('szw/vim-maximizer') -- nice split window toggler
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    -- install without yarn or npm
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
        ft = { "markdown" },
    })

    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }
    use {
        "justinsgithub/oh-my-monokai.nvim",
        config = function()
            require("oh-my-monokai").setup({
                transparent_background = true,
                devicons = true,
                background_clear = {
                    "telescope",
                    "neo-tree"
                }, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree"
                palette = "justinsgithub",
                override = function()
                    return {
                        SpellBad                   = { fg = "NONE", bg = "NONE", style = "undercurl", sp = "#666666" },
                        SpellCap                   = { fg = "NONE", bg = "NONE", style = "undercurl", sp = "#666666" },
                        SpellLocal                 = { fg = "NONE", bg = "NONE", style = "undercurl", sp = "#666666" },
                        SpellRare                  = { fg = "NONE", bg = "NONE", style = "undercurl", sp = "#666666" },
                        CursorLine                 = { bg = "#0D1A35", blend = 60 },
                        DiagnosticVirtualTextError = { bg = "NONE" },
                        DiagnosticVirtualTextWarn  = { bg = "NONE" },
                        DiagnosticVirtualTextInfo  = { bg = "NONE" },
                        DiagnosticVirtualTextHint  = { bg = "NONE" },
                        DiagnosticVirtualTextOk    = { bg = "NONE" },
                    }
                end
            })
            vim.cmd([[colorscheme oh-my-monokai]])
        end
    }
    use {
        "rest-nvim/rest.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    }
    use('mfussenegger/nvim-jdtls')
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'hrsh7th/cmp-vsnip' },
            { 'hrsh7th/vim-vsnip' },
            { 'onsails/lspkind.nvim' },
            { 'L3MON4D3/LuaSnip' }, -- Required
        }
    }
    use {
        'https://gitlab.com/schrieveslaach/sonarlint.nvim',
        as = 'sonarlint.nvim'
    }
    use('mhartington/formatter.nvim')
    use('github/copilot.vim')
end)
