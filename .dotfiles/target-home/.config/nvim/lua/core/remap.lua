vim.g.mapleader = " "

-- Function to switch tabs forward
function SwitchTabsForward()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local last_tab = table.getn(vim.api.nvim_list_tabpages())

    if current_tab == last_tab and os.getenv("TMUX") then
        vim.fn.system("tmux select-window -n")
    else
        vim.cmd("tabnext")
    end
end

-- Function to switch tabs backward
function SwitchTabsBackward()
    local current_tab = vim.api.nvim_get_current_tabpage()

    if current_tab == 1 and os.getenv("TMUX") then
        vim.fn.system("tmux select-window -p")
    else
        vim.cmd("tabprevious")
    end
end

vim.keymap.set('n', '<C-Tab>', '<cmd>lua SwitchTabsForward()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Tab>', '<cmd>lua SwitchTabsBackward()<CR>', { noremap = true, silent = true })

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

-- makes possible to move blocks in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keeps the cursor in the middle of the screen
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever which makes pasting greate again
-- vim.keymap.set("x", "<leader>p", [["_dP]])
-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- do nothing on capital Q or on C-z
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-z>", "<nop>")

vim.keymap.set("n", "<C-q>", "<S-k>")

-- for reformating current word
vim.keymap.set("n", "<C-a-l>", vim.lsp.buf.format)


vim.keymap.set("n", "<leader>j", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>J", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>K", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- maximize and minimize splits
vim.keymap.set("n", "<C-W>m", "<cmd>:MaximizerToggle<CR>")
