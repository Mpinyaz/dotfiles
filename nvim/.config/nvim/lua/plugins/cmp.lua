vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    { "rafamadriz/friendly-snippets" },
    { "AndreM222/copilot-lualine" },
    {
        "David-Kunz/cmp-npm",
        dependencies = { "nvim-lua/plenary.nvim" },
        ft = "json",
        config = function()
            require("cmp-npm").setup({})
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-calc",
            "roobert/tailwindcss-colorizer-cmp.nvim",
            "lukas-reineke/cmp-rg",
            "luckasRanarison/tailwind-tools.nvim",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            {
                "L3MON4D3/LuaSnip",
                version = "2.*",
                dependencies = { "rafamadriz/friendly-snippets" },
                opts = function()
                    local types = require("luasnip.util.types")
                    return {
                        history = true,
                        delete_check_events = "TextChanged",

                        ext_opts = {
                            [types.insertNode] = {
                                unvisited = {
                                    virt_text = { { "|", "Conceal" } },
                                    -- virt_text_pos = "inline",
                                },
                            },
                            [types.exitNode] = {
                                unvisited = {
                                    virt_text = { { "|", "Conceal" } },
                                    -- virt_text_pos = "inline",
                                },
                            },
                        },
                    }
                end,
            },
            {
                "saecki/crates.nvim",
                event = { "BufRead Cargo.toml" },
                tag = "stable",
                ft = { "rust", "toml" },
                requires = { { "nvim-lua/plenary.nvim" } },
                config = function()
                    require("crates").setup({
                        autoload = true,
                        autoupdate = true,
                    })
                end,
            },
            "hrsh7th/cmp-nvim-lua",
            "onsails/lspkind-nvim",
            {
                "hrsh7th/cmp-emoji",
                config = function()
                    require("cmp").setup({
                        sources = {
                            {
                                name = "emoji",
                            },
                        },
                    })
                end,
            },
            {
                "roobert/tailwindcss-colorizer-cmp.nvim",
                config = function()
                    require("tailwindcss-colorizer-cmp").setup({
                        color_square_width = 2,
                    })
                end,
            },
        },
        config = function()
            local cmp = require("cmp")
            local lsp_kind = require("lspkind")
            local snip_status_ok, luasnip = pcall(require, "luasnip")
            if not snip_status_ok then
                return
            end

            local snippets = require("luasnip.loaders.from_vscode")
            snippets.load({
                include = { vim.bo.filetype },
            })
            snippets.lazy_load()
            luasnip.config.set_config({
                history = true,
                region_check_events = "InsertEnter",
                updateevents = "TextChanged,TextChangedI",
                enable_autosnippets = true,
            })

            lsp_kind.init({ mode = "text_symbol", symbol_map = { Copilot = "" } })
            for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("nvim/snippets/*.lua", true)) do
                loadfile(ft_path)()
            end

            cmp.setup({
                enabled = true,
                preselect = cmp.PreselectMode.None,
                view = {
                    entries = "bordered",
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-y>"] = cmp.mapping(
                        cmp.mapping.confirm({
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = true,
                        }),
                        { "i", "c" }
                    ),
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                performance = {
                    trigger_debounce_time = 500,
                    throttle = 550,
                    fetching_timeout = 80,
                },
                formatting = {
                    format = require("lspkind").cmp_format({
                        mode = "text_symbol", -- show only symbol annotations
                        with_text = true,
                        maxwidth = 50,
                        before = require("tailwind-tools.cmp").lspkind_format,
                    }),
                },
                experimental = {
                    ghost_text = {
                        hl_group = "LspCodelens",
                    },
                },
                sources = {
                    {
                        name = "nvim_lsp",
                        max_item_count = 20,
                        group_index = 1,
                    },
                    {
                        name = "luasnip",
                        max_item_count = 5,
                        group_index = 1,
                    },
                    {
                        name = "nvim_lsp_signature_help",
                        group_index = 1,
                    },
                    {
                        name = "copilot",
                        max_item_count = 20,
                        group_index = 2,
                    },
                    {
                        name = "vim-dadbod-completion",
                        group_index = 1,
                    },
                    {
                        name = "path",
                        group_index = 2,
                    },
                    {
                        name = "rg",
                        keyword_length = 2,
                        max_item_count = 5,
                        group_index = 2,
                    },
                    {
                        name = "calc",
                        keyword_length = 2,
                        max_item_count = 5,
                        group_index = 2,
                    },
                    {
                        name = "buffer",
                        keyword_length = 2,
                        max_item_count = 5,
                        group_index = 2,
                    },
                    {
                        name = "treesitter",
                        keyword_length = 2,
                        max_item_count = 5,
                        group_index = 2,
                    },
                    {
                        name = "lazydev",
                        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                    },
                    {
                        name = "tailwindcss_colorizer_cmp",
                        keyword_length = 2,
                        max_item_count = 5,
                        group_index = 2,
                    },
                    {
                        name = "emoji",
                        keyword_length = 2,
                        max_item_count = 5,
                        group_index = 2,
                    },
                    { name = "npm",    keyword_length = 2, max_item_count = 5, group_index = 2 },
                    { name = "crates", keyword_length = 2, max_item_count = 5, group_index = 2 },
                },
            })
            local presentAutopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
            if not presentAutopairs then
                return
            end
            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done({
                    map_char = {
                        tex = "",
                    },
                })
            )
            cmp.config.formatting = {
                format = require("tailwindcss-colorizer-cmp").formatter,
            }

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
            cmp.setup.filetype({ "sql" }, {
                sources = {
                    { name = "vim-dadbod-completion" },
                    { name = "buffer" },
                },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    },
}
