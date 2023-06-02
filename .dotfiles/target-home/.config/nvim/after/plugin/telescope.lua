local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>n', builtin.find_files, {})
vim.keymap.set('n', '<C-n>', builtin.git_files, {})
vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {}) 