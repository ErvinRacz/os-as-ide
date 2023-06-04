vim.g.mapleader = " "

-- Toggle file explorer and restore previous buffer
local explorer_open = false

function ToggleExplorer()
    if explorer_open then
        vim.cmd('Rex')
        explorer_open = false
    else
        vim.cmd('Ex')
        explorer_open = true
    end
end

vim.keymap.set('n', '<leader>`', '<cmd>lua ToggleExplorer()<CR>', { silent = true })
-- vim.keymap.set("n", "<leader>`", vim.cmd.Ex)

-- makes possible to move blocks in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keeps the cursor in the middle of the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever which makes pasting greate again
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- do nothing on capital Q or on C-z
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-z>", "<nop>")

-- for renaming current word
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


-- maximize and minimize splits
-- vim.keymap.set("n", "<C-W>M", "<C-W>=")
-- vim.keymap.set("n", "<C-W>m", "<C-W>|<C-W>_")
