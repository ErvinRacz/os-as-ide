require('dressing').setup({
    input = {
        mappings = {
            n = {
                ["<Esc>"] = "Close",
                ["<CR>"] = "Confirm",
            },
            i = {
                ["<C-c>"] = "Close",
                ["<CR>"] = "Confirm",
                ["<Up>"] = "HistoryPrev",
                ["<Down>"] = "HistoryNext",
            },
        },
    },
    select = {
        get_config = function(opts)
            if opts.kind == 'codeaction' then
                return {
                    backend = 'telescope',
                    trim_prompt = true,
                    telescope = require("telescope.themes").get_ivy({
                        mappings = {
                            i = {
                                ["<tab>"] = "Confirm",
                                ["<cr>"] = "Confirm"
                            },
                            n = {
                                ["<tab>"] = "Confirm",
                                ["<cr>"] = "Confirm"
                            }
                        },
                    }),
                }
            end
        end
    }
})
