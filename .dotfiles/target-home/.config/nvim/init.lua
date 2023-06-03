require("core")

function UpdateTmuxWindowName()
    -- local file_path = vim.fn.expand('%:p')
    -- local root_path = vim.fn.getcwd()
    -- local relative_path = vim.fn.fnamemodify(file_path, ':~:.')
    local file_name = vim.fn.expand('%:t')
    -- os.execute('tmux rename-window "' .. relative_path .. '/' .. file_name .. '"')
    os.execute('tmux rename-window "' .. file_name .. '"')
end

vim.api.nvim_exec([[
    augroup TmuxWindowName
        autocmd!
        autocmd BufEnter * lua UpdateTmuxWindowName()
    augroup END
]], true)
