require('dressing').setup({
    select = {
        get_config = function(opts)
            if opts.kind == 'codeaction' then
                return {
                    backend = 'telescope',
                    trim_prompt = true,
                    telescope = require("telescope.themes").get_ivy({
                        -- these opts are doing nothing almost nothing
                    }),
                }
            end
        end
    }
})
