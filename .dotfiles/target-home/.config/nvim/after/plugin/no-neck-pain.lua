require("no-neck-pain").setup({
    bufferOptions = false,
    width = 130,
    buffers = {
        colors = {
            blend = 0.05,
        },
        scratchPad = {
            -- set to `false` to
            -- disable auto-saving
            enabled = false,
        },
    },
    autocmds = {
        enableOnVimEnter = true,
    },
})
