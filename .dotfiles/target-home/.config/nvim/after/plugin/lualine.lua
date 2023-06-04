require('lualine').setup {
    options = { theme = 'rose-pine' },
    extensions = {'fugitive'},
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', {'diagnostics', symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},}},
        lualine_c = {{'filename', path = 1}},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
}