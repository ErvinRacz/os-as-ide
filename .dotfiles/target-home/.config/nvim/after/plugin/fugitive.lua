vim.keymap.set("n", "<C-k>", "<cmd>:tab G<CR>");

local Core_Fugitive = vim.api.nvim_create_augroup("Core_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
    group = Core_Fugitive,
    pattern = "*",
    callback = function()
        if vim.bo.ft ~= "fugitive" then
            return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false }
        -- print("great success", vim.bo.ft, bufnr, vim.inspect(opts))

        -- rebase always
        vim.keymap.set("n", "<C>p", function()
            vim.cmd [[ Git pull --rebase ]]
        end, opts)


        -- vim.keymap.set("n", "<C>K", function()
        --     vim.cmd [[ Git push ]]
        -- end, opts)

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        -- vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
    end,
})

autocmd("FileType", {
    group = Core_Fugitive,
    pattern = { "gitcommit" },
    callback = function()
        vim.cmd("startinsert")
    end,
})
