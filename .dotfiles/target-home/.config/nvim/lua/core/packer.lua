-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- todo:
    -- call s:h("diffAdded", { "fg": s:green })
    -- call s:h("diffRemoved", { "fg": s:red })
    use { "shortcuts/no-neck-pain.nvim", tag = "*" }

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('windwp/nvim-autopairs')                       -- to auto insert closinng pairs
    use('windwp/nvim-ts-autotag')                      -- to rename html tags
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

    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }

    use({
        "rose-pine/neovim",
        as = "rose-pine",
        config = function()
            require("rose-pine").setup({
                variant = "main",
                bold_vert_split = false,
                dim_nc_background = false,
                disable_background = true,
                disable_float_background = true,
                groups = {
                    punctuation = 'muted',
                    error = "love",
                    hint = "iris",
                    info = "foam",
                    warn = "iris",
                },
                highlight_groups = {
                    -- helpful: https://github.com/rose-pine/neovim/issues/70
                    NormalFloat = { bg = "None" },
                    FloatBorder = { bg = "None" },
                    TelescopeBorder = { bg = "None" },
                    TelescopeNormal = { bg = "None" },
                    TelescopePromptNormal = { bg = "None" },
                    TelescopeResultsNormal = { fg = "subtle", bg = "None" },
                    DiffAdded = { fg = "pine" },
                    DiffRemoved = { fg = "rose" }
                }
            })
            vim.cmd([[ colorscheme rose-pine ]])
        end,
    })

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
            { 'hrsh7th/nvim-cmp' },                  -- Required
            { 'hrsh7th/cmp-nvim-lsp' },              -- Required
            { 'L3MON4D3/LuaSnip' },                  -- Required
        }
    }
end)
