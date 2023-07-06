require("neo-tree").setup({
    window = {
        position = "left",
        width = 45,
        mapping_options = {
            noremap = true,
            nowait = true,
        },
        mappings = {
            ["<tab>"] = {
                "toggle_node",
                nowait = true, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ["<cr>"] = "open",
            ["<esc>"] = "revert_preview",
            ["<c-v>"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ["<c-t>"] = "open_tabnew",
        }
    },
})

vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
