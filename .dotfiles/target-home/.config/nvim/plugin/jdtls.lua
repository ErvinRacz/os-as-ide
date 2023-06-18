-- If you are using linux or mac this file will be located at:
-- ~/.config/nvim/plugin/jdtls.lua

local java_cmds = vim.api.nvim_create_augroup('java_cmds', { clear = true })
local cache_vars = {}

-- `nvim-jdtls` will look for these files/folders
-- to determine the root directory of your project
local root_files = {
    'gradlew',
    'build.gradle',
    'mvnw',
    'pom.xml',
    '.git',
}

local features = {
    -- change this to `true` to enable codelens
    codelens = false,

    -- TODO: change this to true after installing the beloweae plugins
    -- change this to `true` if you have `nvim-dap`,
    -- `java-test` and `java-debug-adapter` installed
    debugger = false,
}

-- we will use this function to get all the paths
-- we need to start the LSP server.
local function get_jdtls_paths()
    if cache_vars.paths then
        return cache_vars.paths
    end

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
    -- Useful if you're starting jdtls with a Java version that's
    -- different from the one the project uses.
    ---
    path.runtimes = {
        -- Note: the field `name` must be a valid `ExecutionEnvironment`,
        -- you can find the list here:
        -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        --
        -- This example assume you are using sdkman: https://sdkman.io
        -- {
        --   name = 'JavaSE-17',
        --   path = vim.fn.expand('~/.sdkman/candidates/java/17.0.6-tem'),
        -- },
        -- {
        --   name = 'JavaSE-18',
        --   path = vim.fn.expand('~/.sdkman/candidates/java/18.0.2-amzn'),
        -- },
    }

    cache_vars.paths = path

    return path
end

-- This function will be executed everytime jdtls
-- gets attached to a file.
-- Here we will create the keybindings.
local function jdtls_on_attach(client, bufnr)
end

-- Here is where we setup nvim-jdtls.
-- This function will be executed everytime you open a java file.
local function jdtls_setup(event)
    local jdtls = require('jdtls')

    local config = {
        cmd = { 'imagine-this-is-the-command-that-starts-jdtls' },
        root_dir = jdtls.setup.find_root(root_files),
        on_attach = jdtls_on_attach,
    }

    jdtls.start_or_attach(config)
end

vim.api.nvim_create_autocmd('FileType', {
    group = java_cmds,
    pattern = { 'java' },
    desc = 'Setup jdtls',
    callback = jdtls_setup,
})
