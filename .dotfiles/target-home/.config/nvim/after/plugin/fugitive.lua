vim.keymap.set("n", "<C-k>", "<cmd>:tab G<CR>");
vim.keymap.set("n", "<C-l>", ":tabedit % | GcLog -S ");

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

local cmpRegistered = false

autocmd("FileType", {
    group = Core_Fugitive,
    pattern = { "gitcommit" },
    callback = function()
        vim.cmd([[cnoreabbrev <buffer> q q!]]) -- apply only to this current buffer
        vim.cmd("startinsert")

        if cmpRegistered then
            return
        end

        cmpRegistered = true

        local has_cmp, cmp = pcall(require, "cmp")
        if not has_cmp then
            return
        end
        -- list of common words from commit messages
        local words = {
            "fix",
            "feat",
            "docs",
            "style",
            "refactor",
            "perf",
            "test",
            "chore",
            "revert",
        }
        -- get task number read from current branch if any with the regular expression
        local task = vim.fn.systemlist("git branch --show-current")[1]:match("([a-zA-Z]+-[0-9]+).*$")

        -- add the two tables together
        local items = vim.tbl_flatten({ words, task })

        local source = {}

        source.new = function()
            return setmetatable({}, { __index = source })
        end

        source.get_trigger_characters = function()
            return { " ", "\n" }
        end

        source.complete = function(self, request, callback)
            local autocompleteItems = {}

            for _, word in ipairs(items) do
                table.insert(autocompleteItems, {
                    label = word,
                    kind = cmp.lsp.CompletionItemKind.Text,
                    filter_text = request.context.cursor_before_line,
                })
            end

            callback({ items = autocompleteItems, isIncomplete = true })
        end

        cmp.register_source("git_commits_common_words", source.new())
        cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
                { name = "git_commits_common_words" },
            })
        })
    end,
})
