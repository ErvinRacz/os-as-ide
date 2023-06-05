-- for copy and pasting from OS clipboard
vim.opt.clipboard:append("unnamedplus")

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- ignorecase tells Vim to use case-insensitive search by default.
vim.opt.ignorecase = true
-- smartcase tells Vim that if any of the search characters are uppercase, treat the search as case-sensitive.
vim.opt.smartcase = true

vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50


vim.opt.winheight = 12
vim.opt.winwidth = 12
vim.opt.winminheight = 4
vim.opt.winminwidth = 4

-- vim.opt.colorcolumn = "80"
vim.opt.fillchars = { eob = ' ' }
