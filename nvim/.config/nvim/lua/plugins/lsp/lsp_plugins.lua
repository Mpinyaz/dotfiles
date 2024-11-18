return {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        {
                "ray-x/lsp_signature.nvim",
                config = function()
                        require("lsp_signature").setup({
                                bind = true, -- This is mandatory, otherwise border config won't get registered.
                                max_height = 12,
                                max_width = 80,
                                transparency = 30,
                                hint_enable = true,
                                shadow_blend = 36,
                                handler_opts = {
                                        border = "rounded",
                                },
                        })
                end,
        },
        {
                "pmizio/typescript-tools.nvim",
                dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
                opts = {},
        },
        {
                "nvimdev/lspsaga.nvim",
                config = function()
                        require("lspsaga").setup({
                                text = {
                                        spinner = "dots",
                                        done = "✓",
                                        commenced = "Started",
                                        completed = "Completed",
                                },
                                align = {
                                        bottom = true,
                                        right = true,
                                },
                                timer = {
                                        spinner_rate = 125,
                                        fidget_decay = 2000,
                                        task_decay = 1000,
                                },
                                window = {
                                        relative = "win",
                                        blend = 0,
                                        zindex = nil,
                                        border = "rounded",
                                },
                        })
                        -- ------------------------------------------------------------------------------
                        local lspsaga = require("lspsaga")
                        lspsaga.setup({
                                -- defaults ...
                                debug = false,
                                use_saga_diagnostic_sign = false,
                                -- diagnostic sign
                                error_sign = "",
                                warn_sign = "",
                                hint_sign = "",
                                infor_sign = "",
                                diagnostic_header_icon = "   ",
                                -- code action title icon
                                code_action_icon = " ",
                                code_action_prompt = {
                                        enable = true,
                                        sign = true,
                                        sign_priority = 40,
                                        virtual_text = false,
                                },
                                finder_definition_icon = "  ",
                                finder_reference_icon = "  ",
                                max_preview_lines = 10,
                                finder_action_keys = {
                                        open = "o",
                                        vsplit = "s",
                                        split = "i",
                                        quit = "q",
                                        scroll_down = "<C-f>",
                                        scroll_up = "<C-b>",
                                },
                                code_action_keys = {
                                        quit = "q",
                                        exec = "<CR>",
                                },
                                rename_action_keys = {
                                        quit = "<C-c>",
                                        exec = "<CR>",
                                },
                                definition_preview_icon = "",
                                border_style = "single",
                                rename_prompt_prefix = "➤",
                                rename_output_qflist = {
                                        enable = false,
                                        auto_open_qflist = false,
                                },
                                server_filetype_map = {},
                                diagnostic_prefix_format = "%d. ",
                                diagnostic_message_format = "%m %c",
                                highlight_prefix = false,
                        })
                end,
                dependencies = {
                        "nvim-treesitter/nvim-treesitter", -- optional
                        "nvim-tree/nvim-web-devicons",     -- optional
                },
        },
        "b0o/schemastore.nvim",
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        {
                "mrcjkb/rustaceanvim",
                version = "^5", -- Recommended
                ft = { "rust" },
                opts = {
                        server = {
                                on_attach = on_attach,
                                default_settings = {
                                        -- rust-analyzer language server configuration
                                        ["rust-analyzer"] = {
                                                check = {
                                                        command = "clippy",
                                                },
                                                checkOnSave = {
                                                        allFeatures = true,
                                                        command = "clippy",
                                                        -- extraArgs = { "--all", "--", "-W", "clippy::all" },
                                                },
                                                assist = {
                                                        importEnforceGranularity = true,
                                                        importPrefix = "crate",
                                                },
                                                cargo = {
                                                        allFeatures = true,
                                                        loadOutDirsFromCheck = true,
                                                        runBuildScripts = true,
                                                },
                                                inlayHints = {
                                                        locationLinks = true,
                                                        lifetimeElisionHints = {
                                                                enable = true,
                                                                useParameterNames = true,
                                                        },
                                                        chainingHints = {
                                                                enable = true,
                                                        },
                                                        renderColons = true,
                                                        typeHints = {
                                                                enable = true,
                                                                hideClosureInitialization = false,
                                                                hideNamedConstructor = false,
                                                        },
                                                },
                                                procMacro = {
                                                        enable = true,
                                                        ignored = {
                                                                leptos_macro = {
                                                                        -- optional: --
                                                                        -- "component",
                                                                        "server",
                                                                },
                                                        },
                                                },
                                        },
                                },
                        },
                },
                config = function()
                        -- vim.lsp.inlay_hint.enable()
                end,
        },
        {
                "chrisgrieser/nvim-lsp-endhints",
                event = "LspAttach",
                opts = {}, -- required, even if empty
        },
        {
                "rust-lang/rust.vim",
                ft = "rust",
                init = function()
                        vim.g.rustfmt_autosave = 1
                end,
        },

        {
                "neovim/nvim-lspconfig",
                dependencies = { "hrsh7th/cmp-nvim-lsp" },
                config = function()
                        require("config.lspconfig")
                end,
                opts = {
                        library = { plugins = { "neotest", "nvim-dap-ui" }, types = true },
                },
        },
}
