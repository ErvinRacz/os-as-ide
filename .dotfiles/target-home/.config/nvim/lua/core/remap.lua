vim.g.mapleader = " "

function GetTmuxWindowCount()
    local command = "tmux list-windows | wc -l"
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    return tonumber(result)
end

-- Function to switch tabs forward
function SwitchTabsForward()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local last_tab = #vim.api.nvim_list_tabpages()

    if current_tab == last_tab and os.getenv("TMUX") and GetTmuxWindowCount() > 1 then
        vim.fn.system("tmux select-window -n")
    else
        vim.cmd("tabnext")
    end
end

-- Function to switch tabs backward
function SwitchTabsBackward()
    local current_tab = vim.api.nvim_get_current_tabpage()

    if current_tab == 1 and os.getenv("TMUX") and GetTmuxWindowCount() > 1 then
        vim.fn.system("tmux select-window -p")
    else
        vim.cmd("tabprevious")
    end
end

function OpenNewTmuxWindow()
    vim.fn.system(string.format("tmux new-window -c '#{pane_current_path}'"))
end

vim.keymap.set('n', '<C-Tab>', '<cmd>lua SwitchTabsForward()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Tab>', '<cmd>lua SwitchTabsBackward()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-t>', '<cmd>lua OpenNewTmuxWindow()<CR>', { noremap = true, silent = true })

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
vim.keymap.set("n", "q:", "<cmd>q<CR>")
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

--#region Copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap('i', '<ESC>[27;13;9;13~', ':echo "Control+Enter was pressed"<CR>', { silent = true })
vim.api.nvim_set_keymap("i", "<C-cr>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
--#endregion

function CloseTabOrQuitAll(bang)
    local tab_count = #vim.api.nvim_list_tabpages()
    if tab_count > 1 then
        vim.cmd(bang and "tabclose!" or "tabclose")
    else
        vim.cmd(bang and "qa!" or "qa")
    end
end

vim.api.nvim_create_user_command("CloseTabOrQuitAll", function(opts)
    CloseTabOrQuitAll(opts.bang)
end, { bang = true })

-- Use :tabclose on :qa and fix common typos
vim.cmd([[
    cnoreabbrev W! w!
    cnoreabbrev W1 w!
    cnoreabbrev w1 w!
    cnoreabbrev Q! q!
    cnoreabbrev Q1 q!
    cnoreabbrev q1 q!
    cnoreabbrev Qa! CloseTabOrQuitAll!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wa wa
    cnoreabbrev Wq wq
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev wq1 wq!
    cnoreabbrev Wq1 wq!
    cnoreabbrev wQ1 wq!
    cnoreabbrev WQ1 wq!
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qa CloseTabOrQuitAll
    cnoreabbrev qa CloseTabOrQuitAll
    cnoreabbrev Qall qall
]])
