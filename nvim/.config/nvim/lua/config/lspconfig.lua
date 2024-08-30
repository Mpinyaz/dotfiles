local servers = {
        pyright = {},
        bashls = { filetypes = { "sh", "zsh" } },
        cmake = {},
        omnisharp = {},
        tsserver = require("plugins.lsp.servers.tsserver")(on_attach),
        vimls = {},
        lua_ls = require("plugins.lsp.servers.luals")(on_attach),
        html = {
                init_options = {
                        configurationSection = { "html", "css", "javascript" },
                        embeddedLanguages = {
                                css = true,
                                javascript = true,
                        },
                        provideFormatter = true,
                },
        },
        jsonls = {
                settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } },
        },
        cssls = {},
        tailwindcss = {},
        clangd = require("plugins.lsp.servers.clangd")(on_attach),
        taplo = {},
        markdown_oxide = {},
        yamlls = {
                -- Have to add this for yamlls to understand that we support line folding
                capabilities = { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } },
                settings = {
                        redhat = { telemetry = { enabled = false } },
                        yaml = {
                                schemas = require("schemastore").yaml.schemas(),
                                keyOrdering = false,
                                format = { enable = true },
                                validate = true,
                                schemaStore = {
                                        --Must disable built-in schemaStore support to use schemas from SchemaStore.nvim plugin
                                        enable = false,
                                        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                                        url = "",
                                },
                        },
                },
        },
}

local server_names = {}
for server_name, _ in pairs(servers) do
        table.insert(server_names, server_name)
end

-- Install the LSP servers automatically using mason-lspconfig
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
        return
end

mason.setup({
        ensure_installed = server_names,
        automatic_installation = true,
        ui = {
                border = "shadow",
                icons = require("utils.icons").mason,
                check_outdated_packages_on_open = true,
        },
})

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_ok then
        mason_lspconfig.setup({
                ensure_installed = server_names,
                automatic_installation = true,
                ui = {
                        border = "shadow",
                        icons = require("utils.icons").mason,
                        check_outdated_packages_on_open = true,
                },
        })
end

require("lsp_lines").setup()

-- Init for lspconfig
local lspconfig_ok, lspconfig = pcall(require, "lspconfig") -- Must call after lsp installer
if not lspconfig_ok then
        return
end

local _, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local icons = require("utils.icons")

local capabilities =
    vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities(), {
            textDocument = {
                    foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
                    completion = {
                            completionItem = {
                                    documentationFormat = { "markdown", "plaintext" },
                                    snippetSupport = true,
                                    preselectSupport = true,
                                    insertReplaceSupport = true,
                                    labelDetailsSupport = true,
                                    deprecatedSupport = true,
                                    commitCharactersSupport = true,
                                    tagSupport = { valueSet = { 1 } },
                                    resolveSupport = {
                                            properties = {
                                                    "documentation",
                                                    "detail",
                                                    "additionalTextEdits",
                                            },
                                    },
                            },
                    },
            },
    })

local signs = {
        {
                name = "DiagnosticSignError",
                text = icons.diagnostics.error,
        },
        {
                name = "DiagnosticSignWarn",
                text = icons.diagnostics.warning,
        },
        {
                name = "DiagnosticSignHint",
                text = icons.diagnostics.hint,
        },
        {
                name = "DiagnosticSignInfo",
                text = icons.diagnostics.information,
        },
}

for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, {
                texthl = sign.name,
                text = sign.text,
                numhl = "",
        })
end

local telescope_ok, telescope = pcall(require, "telescope.builtin")

-- Wrapper for keymapping with default opts
local map = function(mode, lhs, rhs, desc)
        local opts = {
                noremap = true,
                silent = true,
                desc = "LSP: " .. desc,
        }
        vim.keymap.set(mode, lhs, rhs, opts)
end

local bufmap = function(mode, lhs, rhs, bufnr, desc)
        local bufopts = {
                noremap = true,
                silent = true,
                buffer = bufnr,
                desc = "LSP: " .. desc,
        }
        vim.keymap.set(mode, lhs, rhs, bufopts)
end

-- Mappings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
map("n", "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", "Go to next diagnostic")
map("n", "ge", "<Cmd>Lspsaga show_line_diagnostic<CR>", "Show diagnostics of the current line")
map("n", "gd", "<Cmd>Lspsaga peek_definition<CR>", "Show diagnostics of the current line")
map("n", "gr", "<Cmd>Lspsaga rename ++projects<CR>", "Rename variable under cursor")
map("n", "<leader>ca", "<Cmd>Lspsaga code_action<CR>", "Code actions")
map("n", "gf", "<Cmd>Lspsaga finder<CR>", "Find references and implementation under cursor")
map("n", "K", "<cmd>Lspsaga hover_doc", "Show hover doc")
map("n", "go", "<cmd>Lspsaga outline", "Show Lsp outline")
map("n", "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "Go to the previous diagnostic")
if telescope_ok then
        map("n", "<leader>d", telescope.diagnostics, "Show all diagnostics")
else
        map("n", "<leader>E", function()
                vim.diagnostic.setloclist()
        end, "Show all diagnostics")
end
-----------------------------------------------------------

local function on_attach(client, bufnr)
        local function buf_set_keymap(...)
                vim.api.nvim_buf_set_keymap(bufnr, ...)
        end

        -- Mappings
        local opts = { noremap = true, silent = true }
        buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
        buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

        if client.server_capabilities.documentFormattingProvider then
                buf_set_keymap("n", "<leader>Cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
        end

        if client.server_capabilities.documentRangeFormattingProvider then
                buf_set_keymap("v", "<leader>cf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        end
end

local config = {
        virtual_text = false, -- appears after the line
        virtual_lines = true, -- appears under the line
        signs = {
                active = signs,
        },
        flags = {
                debounce_text_changes = 200,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
                focus = false,
                focusable = false,
                style = "minimal",
                border = "shadow",
                source = "always",
                header = "",
                prefix = "",
        },
}

lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, config)
vim.diagnostic.config(config)

local default_lsp_config = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
                debounce_text_changes = 200,
                allow_incremental_sync = true,
        },
}

for server_name, server_config in pairs(servers) do
        local merged_config = vim.tbl_deep_extend("force", default_lsp_config, server_config)
        lspconfig[server_name].setup(merged_config)
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        silent = true,
        border = "rounded",
})

vim.keymap.set("", "<Leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Show hover doc" })
