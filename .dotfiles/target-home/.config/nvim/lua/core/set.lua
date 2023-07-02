-- reduce neovim's footprint
-- The practical effect of this change means that all plugins I choose are native vimscript and Lua only. So far, I haven’t found this change too limiting but time will tell
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
-- to look for quality neovim plugins, take a look at this awesome collection: https://github.com/rockerBOO/awesome-neovim

-- disable netrw at the very start of your init.lua - needed for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- spell check
vim.opt.spelllang = 'en_us'
vim.opt.spell = true

-- for copy and pasting from OS clipboard
vim.opt.clipboard:append("unnamedplus")

vim.opt.nu = true
vim.opt.relativenumber = true

-- highlighted cursor line
vim.opt.cul = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- ignore case tells Vim to use case-insensitive search by default.
vim.opt.ignorecase = true
-- smart case tells Vim that if any of the search characters are uppercase, treat the search as case-sensitive.
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
