local builtin = require('telescope.builtin')
local actions = require("telescope.actions")
local fb_actions = require "telescope._extensions.file_browser.actions"

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

local finders_config = {
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
    find_files = {
        hidden = true,
    },
    file_ignore_patterns = {
        ".git/",
        ".cache",
        "package%-lock%.json",
        "%.o",
        "%.a",
        "%.out",
        "%.class",
        "node_modules/",
        "dist/",
        "build/",
        "target/",
        "tmp/",
        "temp/",
        "cache/",
        "logs/",
        "coverage/",
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
    },
}

require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<tab>"] = actions.select_default,
                ["<c-k>"] = actions.move_selection_previous,
                ["<c-j>"] = actions.move_selection_next,
                ["<c-t>"] = function(prompt_bufnr)
                    actions.select_tab(prompt_bufnr)
                end,
            },
            n = {
                ["<tab>"] = actions.select_default,
                ["<c-k>"] = actions.move_selection_previous,
                ["<c-t>"] = function(prompt_bufnr)
                    actions.select_tab(prompt_bufnr)
                end,
            }
        },
    },
    pickers = {
        find_files = finders_config,
        git_files = finders_config,
        live_grep = finders_config,
        grep_string = finders_config,
    },
    extensions = {
        file_browser = {
            theme = "ivy",
            initial_mode = "normal",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            hidden = { file_browser = true, folder_browser = true },
            mappings = {
                ["i"] = {
                    ["<C-a>"] = fb_actions.create,
                    -- ["<C-m>"] = fb_actions.create_from_prompt,
                    ["<F2>"] = fb_actions.rename,
                    ["<C-m>"] = fb_actions.move,
                    ["<C-c>"] = fb_actions.copy,
                    ["<C-d>"] = fb_actions.remove,
                    ["<C-o>"] = fb_actions.open,
                    ["<C-g>"] = fb_actions.goto_parent_dir,
                    ["<C-r>"] = fb_actions.goto_home_dir,
                    ["<C-e>"] = fb_actions.goto_cwd,
                    -- ["<C-t>"] = fb_actions.change_cwd,
                    -- ["<C-f>"] = fb_actions.toggle_browser,
                    ["<C-h>"] = fb_actions.toggle_hidden,
                    ["<C-s>"] = fb_actions.toggle_all,
                    ["<bs>"] = fb_actions.backspace,
                    ["<tab>"] = actions.toggle_selection + actions.move_selection_previous,
                    ["<cr>"] = actions.file_edit,
                },
                ["n"] = {
                    ["/"] = function() vim.cmd("startinsert") end,
                    -- ["<C-f>"] = function() vim.cmd("startinsert") end,
                    ["a"] = fb_actions.create,
                    ["<F2>"] = fb_actions.rename,
                    ["m"] = fb_actions.move,
                    ["c"] = fb_actions.copy,
                    ["d"] = fb_actions.remove,
                    ["o"] = fb_actions.open,
                    ["g"] = fb_actions.goto_parent_dir,
                    ["r"] = fb_actions.goto_home_dir,
                    ["e"] = fb_actions.goto_cwd,
                    -- ["t"] = fb_actions.change_cwd,
                    ["<leader>`"] = fb_actions.toggle_browser,
                    ["h"] = fb_actions.toggle_hidden,
                    ["s"] = fb_actions.toggle_all,
                    ["<bs>"] = fb_actions.backspace,
                    ["<tab>"] = actions.toggle_selection + actions.move_selection_previous,
                },
            },
        },
    }
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

-- open file_browser with the path of the current buffer
vim.keymap.set(
    "n",
    "<leader>`",
    ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
    { noremap = true }
)

require("telescope").load_extension("file_browser")
require("telescope").load_extension("live_grep_args")
