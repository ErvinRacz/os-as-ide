local builtin = require('telescope.builtin')
local actions = require("telescope.actions")

function SendToQuickFixList(prompt_bufnr)
    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
    local num_selections = #picker:get_multi_selection()

    if num_selections > 1 then
        -- actions.file_edit throws - context of picker seems to change
        --actions.file_edit(prompt_bufnr)
        actions.send_selected_to_qflist(prompt_bufnr)
        -- actions.open_qflist() / becaouse it would open the qflist to the right
        vim.cmd([[botright copen]])
    else
        actions.file_edit(prompt_bufnr)
    end
end

require('telescope').setup {
    defaults = {
        layout_strategy = "vertical",
        layout_config = {
            vertical = { width = 0.8, height = 0.98 },
            preview_height = 0.62
        },
        vimgrep_arguments = {
            'rg',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
        },
        -- default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                ["<tab>"] = actions.toggle_selection + actions.move_selection_previous,
                ["<cr>"] = SendToQuickFixList
            },
            n = {
                ["<tab>"] = actions.toggle_selection + actions.move_selection_previous,
                ["<cr>"] = SendToQuickFixList
            }
        }
    },
}

-- Function to execute the command and handle errors
local function find_files()
  local success, error_message = pcall(builtin.git_files)
  if not success then
      builtin.find_files()
  end
end

vim.keymap.set('n', '<C-n>', find_files, {})
vim.keymap.set('n', '<leader>n', builtin.find_files, {})
vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
vim.keymap.set('n', '<leader>f', builtin.grep_string, { silent = true, noremap = true })
