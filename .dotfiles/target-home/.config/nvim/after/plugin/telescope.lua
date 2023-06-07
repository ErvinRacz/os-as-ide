local builtin = require('telescope.builtin')
local previewers = require('telescope.previewers')


function OpenInTmuxWindow(prompt_bufnr)
    local selection = require("telescope.actions.state").get_selected_entry()
    local path = selection.path
    require("telescope.actions").close(prompt_bufnr)

    -- Run the tmux command to open a new window and open the file
    vim.fn.system(string.format("tmux new-window 'nvim %s'", path))
end


require('telescope').setup {
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
        },
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                ["<C-w>"] = OpenInTmuxWindow,
            },
            n = {
                ["<C-w>"] = OpenInTmuxWindow,
            }
        }
    },
}

vim.keymap.set('n', '<C-n>', builtin.git_files, {})
vim.keymap.set('n', '<leader>n', builtin.find_files, {})
vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
vim.keymap.set('n', '<leader>f', builtin.grep_string, { silent = true, noremap = true })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {}) 
