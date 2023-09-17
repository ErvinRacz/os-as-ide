vim.g.mapleader = " "

function GetTmuxWindowCount()
    local command = "tmux list-windows | wc -l"
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    local count = tonumber(result)
    return count
end

-- Function to switch tabs forward
function SwitchTabsForward()
    local current_tab = vim.api.nvim_get_current_tabpage()

    local tabs = vim.api.nvim_list_tabpages()
    local last_tab = tabs[#tabs]

    vim.cmd("stopinsert")
    if current_tab == last_tab and GetTmuxWindowCount() > 1 then
        vim.cmd("TmuxSelectNextWindow")
    else
        vim.cmd("tabnext")
    end
end

-- Function to switch tabs backward
function SwitchTabsBackward()
    local current_tab = vim.api.nvim_get_current_tabpage()

    vim.cmd("stopinsert")
    if current_tab == 1 and GetTmuxWindowCount() > 1 then
        vim.cmd("TmuxSelectPreviousWindow")
    else
        vim.cmd("tabprevious")
    end
end

vim.keymap.set('n', '<C-Tab>', '<cmd>lua SwitchTabsForward()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-Tab>', '<cmd>lua SwitchTabsBackward()<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-Tab>', '<esc><cmd>lua SwitchTabsForward()<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-S-Tab>', '<esc><cmd>lua SwitchTabsBackward()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-t>', '<cmd>TmuxSelectNonNvimWindow<CR>', { noremap = true, silent = true })

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
vim.keymap.set("n", "<C-a-l>", "<cmd>FormatWrite<CR>")
vim.keymap.set("v", "<C-a-l>", "=")
-- autoformat on save - before writing to file
local FormatAutogroup = vim.api.nvim_create_augroup("FormatAutogroup", {})
vim.api.nvim_create_autocmd("BufWritePost", {
    group = FormatAutogroup,
    pattern = "*",
    callback = function()
        vim.cmd("FormatWrite")
    end
})

vim.keymap.set("n", "<leader>j", "<cmd>cnext<cr>zz")
vim.keymap.set("n", "<leader>k", "<cmd>cprev<cr>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lnext<cr>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lprev<cr>zz")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- maximize and minimize splits
vim.keymap.set("n", "<C-W>m", "<cmd>:MaximizerToggle<CR>")

--#region Copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<a-9>", 'copilot#Accept("<Tab>")', { expr = true, silent = true }) -- map <C-Enter> aka <a-9>
vim.api.nvim_set_keymap("i", "<C-l>", '<Plug>(copilot-next)', { silent = true })

vim.api.nvim_create_user_command("Cop", function(opts)
    vim.cmd("Copilot panel")
end, {})

vim.keymap.set("n", "<leader>cp", "<cmd>Cop<CR>", { silent = true })
--#endregion
vim.api.nvim_set_keymap("n", "<leader>r", '<Plug>RestNvim', { silent = true })

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
