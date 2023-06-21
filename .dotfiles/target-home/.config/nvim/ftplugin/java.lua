local java_cmds = vim.api.nvim_create_augroup('java_cmds', { clear = true })
local jdtls = require('jdtls')

-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
local root_files = {
    -- Single-module projects
    {
        'build.xml',           -- Ant
        'pom.xml',             -- Maven
        'settings.gradle',     -- Gradle
        'settings.gradle.kts', -- Gradle
    },
    -- Multi-module projects
    { 'build.gradle', 'build.gradle.kts' },
}

local features = {
    -- change this to `true` to enable codelens
    codelens = false,

    -- TODO: change this to true after installing the beloweae plugins
    -- change this to `true` if you have `nvim-dap`,
    -- `java-test` and `java-debug-adapter` installed
    debugger = false,
}

local function enable_codelens(bufnr)
    pcall(vim.lsp.codelens.refresh)

    vim.api.nvim_create_autocmd('BufWritePost', {
        buffer = bufnr,
        group = java_cmds,
        desc = 'refresh codelens',
        callback = function()
            pcall(vim.lsp.codelens.refresh)
        end,
    })
end

local function enable_debugger(bufnr)
    jdtls.setup_dap({ hotcodereplace = 'auto' })
    require('jdtls.dap').setup_dap_main_class_configs()

    local opts = { buffer = bufnr }
    vim.keymap.set('n', '<leader>df', "<cmd>lua require('jdtls').test_class()<cr>", opts)
    vim.keymap.set('n', '<leader>dn', "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)
end

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.

local function get_jdtls_paths()
    local path = {}

    path.data_dir = vim.fn.stdpath('cache') .. '/nvim-jdtls'

    local jdtls_install = require('mason-registry')
        .get_package('jdtls')
        :get_install_path()

    path.java_agent = jdtls_install .. '/lombok.jar'
    path.launcher_jar = vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar')

    if vim.fn.has('mac') == 1 then
        path.platform_config = jdtls_install .. '/config_mac'
    elseif vim.fn.has('unix') == 1 then
        path.platform_config = jdtls_install .. '/config_linux'
    elseif vim.fn.has('win32') == 1 then
        path.platform_config = jdtls_install .. '/config_win'
    end

    path.bundles = {}

    ---
    -- Include java-test bundle if present
    ---
    local java_test_path = require('mason-registry')
        .get_package('java-test')
        :get_install_path()

    local java_test_bundle = vim.split(
        vim.fn.glob(java_test_path .. '/extension/server/*.jar'),
        '\n'
    )

    if java_test_bundle[1] ~= '' then
        vim.list_extend(path.bundles, java_test_bundle)
    end

    ---
    -- Include java-debug-adapter bundle if present
    ---
    local java_debug_path = require('mason-registry')
        .get_package('java-debug-adapter')
        :get_install_path()

    local java_debug_bundle = vim.split(
        vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'),
        '\n'
    )

    if java_debug_bundle[1] ~= '' then
        vim.list_extend(path.bundles, java_debug_bundle)
    end

    ---
    -- If you are developing in projects with different Java versions, you need
    -- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- And search for `interface RuntimeOption`
    -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
    ---
    path.runtimes = {
        {
            name = 'JavaSE-17',
            path = vim.fn.expand('~/.asdf/installs/java/zulu-17.42.19'),
        },
        -- {
        --   name = 'JavaSE-19',
        --   path = vim.fn.expand('~/.asdf/installs/java/zulu-17.42.19'),
        -- },
    }

    return path
end

local path = get_jdtls_paths()
local data_dir = path.data_dir .. '/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')


-- This function will be executed everytime jdtls
-- gets attached to a file.
-- Here we will create the keybindings.
local function jdtls_on_attach(client, bufnr)
    if features.debugger then
        enable_debugger(bufnr)
    end

    if features.codelens then
        enable_codelens(bufnr)
    end

    -- The following mappings are based on the suggested usage of nvim-jdtls
    -- https://github.com/mfussenegger/nvim-jdtls#usage

    local opts = { buffer = bufnr }
    vim.keymap.set('n', '<a-o>', "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
    vim.keymap.set('n', '<c-a-v>', "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
    vim.keymap.set('x', '<c-a-v>', "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
    vim.keymap.set('n', '<c-a-c>', "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
    vim.keymap.set('x', '<c-a-c>', "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
    vim.keymap.set('n', '<c-a-e>', "<cmd>lua require('jdtls').extract_method(true)<cr>", opts)
end

local config = {
    flags = {
        debounce_text_changes = 80,
    },
    on_attach = jdtls_on_attach, -- We pass our on_attach keybindings to the configuration map
    root_dir = jdtls.setup.find_root(root_files),
    single_file_support = true,
    -- Here you can configure eclipse.jdt.ls specific settings
    -- These are defined by the eclipse.jdt.ls project and will be passed to eclipse when starting.
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
        java = {
            format = {
                settings = {
                    -- Use Google Java style guidelines for formatting
                    -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
                    -- and place it in the ~/.local/share/eclipse directory
                    url = "/.local/share/eclipse/eclipse-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' }, -- Use fernflower to decompile library code
            -- Specify any completion options
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*"
                },
                -- filteredTypes = {
                --     "com.sun.*",
                --     "io.micrometer.shaded.*",
                --     "java.awt.*",
                --     "jdk.*", "sun.*",
                -- },
            },
            -- Specify any options for organizing imports
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            -- How code generation should act
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                },
                hashCodeEquals = {
                    useJava7Objects = true,
                },
                useBlocks = true,
            },
            -- If you are developing in projects with different Java versions, you need
            -- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
            -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
            -- And search for `interface RuntimeOption`
            -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
            configuration = {
                runtimes = path.runtimes
            }
        }
    },
    -- cmd is the command that starts the language server. Whatever is placed
    -- here is what is passed to the command line to execute jdtls.
    -- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    -- for the full list of options
    cmd = {
        -- 💀
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-javaagent:' .. path.java_agent,
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',
        -- 💀
        '-jar',
        path.launcher_jar,
        -- 💀
        '-configuration',
        path.platform_config,
        -- 💀
        '-data',
        data_dir,
    },
}

-- Finally, start jdtls. This will run the language server using the configuration we specified,
-- setup the keymappings, and attach the LSP client to the current buffer
jdtls.start_or_attach(config)
