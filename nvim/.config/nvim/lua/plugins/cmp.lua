vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.shortmess:append 'c'

return {
        { 'rafamadriz/friendly-snippets' },
        { 'AndreM222/copilot-lualine' },
        {
                'David-Kunz/cmp-npm',
                dependencies = { 'nvim-lua/plenary.nvim' },
                ft = 'json',
                config = function()
                        require('cmp-npm').setup {}
                end,
        },
        {
                'luckasRanarison/tailwind-tools.nvim',
                name = 'tailwind-tools',
                build = 'UpdateRemotePlugins',
                dependencies = {
                        'nvim-treesitter/nvim-treesitter',
                        'nvim-telescope/telescope.nvim', -- optional
                        'neovim/nvim-lspconfig', -- optional
                },
                opts = {},             -- your configuration
                config = function()
                        require('tailwind-tools').setup {
                                lsp = {
                                        enabled = true,
                                        debounce = 150,
                                },
                                telescope = {
                                        enabled = true,
                                },
                        }
                end,
        },
        {
                'hrsh7th/nvim-cmp',
                event = 'InsertEnter',
                dependencies = {
                        'hrsh7th/cmp-nvim-lsp-signature-help',
                        'hrsh7th/cmp-nvim-lsp',
                        'hrsh7th/cmp-calc',
                        'roobert/tailwindcss-colorizer-cmp.nvim',
                        'lukas-reineke/cmp-rg',
                        'luckasRanarison/tailwind-tools.nvim',
                        'hrsh7th/cmp-buffer',
                        'hrsh7th/cmp-path',
                        'hrsh7th/cmp-cmdline',
                        'windwp/nvim-autopairs',
                        'saadparwaiz1/cmp_luasnip',
                        'brenoprata10/nvim-highlight-colors',
                        {
                                'L3MON4D3/LuaSnip',
                                version = '2.*',
                                dependencies = { 'rafamadriz/friendly-snippets' },
                                opts = function()
                                        local types = require 'luasnip.util.types'
                                        return {
                                                history = true,
                                                delete_check_events = 'TextChanged',

                                                ext_opts = {
                                                        [types.insertNode] = {
                                                                unvisited = {
                                                                        virt_text = { { '|', 'Conceal' } },
                                                                        -- virt_text_pos = "inline",
                                                                },
                                                        },
                                                        [types.exitNode] = {
                                                                unvisited = {
                                                                        virt_text = { { '|', 'Conceal' } },
                                                                        -- virt_text_pos = "inline",
                                                                },
                                                        },
                                                },
                                        }
                                end,
                        },
                        {
                                'saecki/crates.nvim',
                                event = { 'BufRead Cargo.toml' },
                                tag = 'stable',
                                ft = { 'rust', 'toml' },
                                requires = { { 'nvim-lua/plenary.nvim' } },
                                config = function()
                                        require('crates').setup {
                                                autoload = true,
                                                autoupdate = true,
                                        }
                                end,
                        },
                        'hrsh7th/cmp-nvim-lua',
                        'onsails/lspkind-nvim',
                        {
                                'hrsh7th/cmp-emoji',
                                config = function()
                                        require('cmp').setup {
                                                sources = {
                                                        {
                                                                name = 'emoji',
                                                        },
                                                },
                                        }
                                end,
                        },
                },
                config = function()
                        local cmp = require 'cmp'
                        local lsp_kind = require 'lspkind'
                        local snip_status_ok, luasnip = pcall(require, 'luasnip')
                        if not snip_status_ok then
                                return
                        end

                        local snippets = require 'luasnip.loaders.from_snipmate'
                        snippets.load {
                                include = { vim.bo.filetype },
                        }
                        snippets.lazy_load()
                        luasnip.config.set_config {
                                history = true,
                                region_check_events = 'InsertEnter',
                                updateevents = 'TextChanged,TextChangedI',
                                enable_autosnippets = true,
                        }

                        lsp_kind.init { mode = 'text_symbol', symbol_map = { Copilot = '' } }
                        for _, ft_path in ipairs(vim.api.nvim_get_runtime_file('nvim/snippets/*.lua', true)) do
                                loadfile(ft_path)()
                        end

                        local has_words_before = function()
                                local unpack = unpack or table.unpack ---@diagnostic disable-line: deprecated
                                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                                return col ~= 0 and
                                vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
                        end
                        local t = function(str)
                                return vim.api.nvim_replace_termcodes(str, true, true, true)
                        end
                        cmp.setup {
                                enabled = true,
                                preselect = cmp.PreselectMode.None,
                                view = {
                                        entries = 'bordered',
                                },
                                completion = {
                                        keyword_length = 1,
                                        completeopt = 'menu,menuone,noinsert',
                                },
                                snippet = {
                                        expand = function(args)
                                                luasnip.lsp_expand(args.body)
                                        end,
                                },
                                mapping = {
                                        ['<C-j>'] = cmp.mapping.scroll_docs(-4),
                                        ['<C-k>'] = cmp.mapping.scroll_docs(4),
                                        ['<C-Space>'] = cmp.mapping.complete(),
                                        ['<C-e>'] = cmp.mapping.abort(),
                                        ['<Tab>'] = cmp.mapping(function(fallback)
                                                if luasnip.expand_or_jumpable() then
                                                        luasnip.expand_or_jump()
                                                else
                                                        fallback()
                                                end
                                        end, { 'i', 's' }),

                                        ['<S-Tab>'] = cmp.mapping(function(fallback)
                                                if luasnip.jumpable(-1) then
                                                        luasnip.jump(-1)
                                                else
                                                        fallback()
                                                end
                                        end, { 'i', 's' }),

                                        ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
                                        ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                                        ['<C-y>'] = cmp.mapping(
                                                cmp.mapping.confirm {
                                                        behavior = cmp.ConfirmBehavior.Replace,
                                                        select = true,
                                                },
                                                { 'i', 'c' }
                                        ),
                                },
                                window = {
                                        completion = cmp.config.window.bordered {
                                                winhighlight = 'Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None',
                                        },
                                        documentation = cmp.config.window.bordered {
                                                winhighlight = 'Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None',
                                        },
                                },
                                performance = {
                                        trigger_debounce_time = 500,
                                        throttle = 550,
                                        fetching_timeout = 80,
                                },
                                formatting = {

                                        format = function(entry, item)
                                                local color_item = require('nvim-highlight-colors').format(entry,
                                                        { kind = item.kind })
                                                item = require('lspkind').cmp_format {
                                                        mode = 'text_symbol',
                                                        with_text = true,
                                                        maxwidth = 50,
                                                        ellipsis_char = '...',
                                                        show_labelDetails = true,
                                                } (entry, item)
                                                if color_item.abbr_hl_group then
                                                        item.kind_hl_group = color_item.abbr_hl_group
                                                        item.kind = color_item.abbr
                                                end
                                                return item
                                        end,
                                },
                                sources = {
                                        {
                                                name = 'nvim_lsp',
                                                max_item_count = 20,
                                                group_index = 1,
                                        },
                                        {
                                                name = 'luasnip',
                                                max_item_count = 5,
                                                group_index = 1,
                                        },
                                        {
                                                name = 'vim-dadbod-completion',
                                                group_index = 1,
                                        },
                                        {
                                                name = 'path',
                                                group_index = 2,
                                        },
                                        {
                                                name = 'rg',
                                                keyword_length = 2,
                                                max_item_count = 5,
                                                group_index = 2,
                                        },
                                        {
                                                name = 'calc',
                                                keyword_length = 2,
                                                max_item_count = 5,
                                                group_index = 2,
                                        },
                                        {
                                                name = 'buffer',
                                                keyword_length = 2,
                                                max_item_count = 5,
                                                group_index = 2,
                                        },
                                        {
                                                name = 'treesitter',
                                                keyword_length = 2,
                                                max_item_count = 5,
                                                group_index = 2,
                                        },
                                        {
                                                name = 'lazydev',
                                                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                                        },
                                        {
                                                name = 'emoji',
                                                keyword_length = 2,
                                                max_item_count = 5,
                                                group_index = 2,
                                        },
                                        { name = 'npm',    keyword_length = 2, max_item_count = 5, group_index = 2 },
                                        { name = 'crates', keyword_length = 2, max_item_count = 5, group_index = 2 },
                                },
                        }
                        local presentAutopairs, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
                        if not presentAutopairs then
                                return
                        end
                        cmp.event:on(
                                'confirm_done',
                                cmp_autopairs.on_confirm_done {
                                        map_char = {
                                                tex = '',
                                        },
                                }
                        )
                        cmp.config.formatting = {
                                format = require('tailwindcss-colorizer-cmp').formatter,
                        }

                        cmp.setup.cmdline({ '/', '?' }, {
                                mapping = cmp.mapping.preset.cmdline(),
                                sources = {
                                        { name = 'buffer' },
                                },
                        })
                        cmp.setup.filetype({ 'sql' }, {
                                sources = {
                                        { name = 'vim-dadbod-completion' },
                                        { name = 'buffer' },
                                },
                        })
                        cmp.setup.cmdline(':', {
                                mapping = cmp.mapping.preset.cmdline(),
                                sources = cmp.config.sources({
                                        { name = 'path' },
                                }, {
                                        { name = 'cmdline' },
                                }),
                        })
                end,
        },
}
