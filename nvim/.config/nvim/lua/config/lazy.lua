local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
        -- bootstrap lazy.nvim
        -- stylua: ignore
        vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                lazypath })
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
local lazy_plugins = {
        {
                'vhyrro/luarocks.nvim',
                priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
                config = true,
        },
        {
                'luckasRanarison/tailwind-tools.nvim',
                dependencies = { 'nvim-treesitter/nvim-treesitter' },
                opts = {}, -- your configuration
        },
        {
                'tzachar/highlight-undo.nvim',
                event = 'VeryLazy',
                opts = {},
                config = function()
                        require('highlight-undo').setup {}
                end,
        },
        {
                'piersolenski/wtf.nvim',
                dependencies = {
                        'MunifTanjim/nui.nvim',
                },
                opts = {},
                --stylua: ignore
                keys = {
                        { "<leader>sD", function() require("wtf").ai() end,     desc = "Search Diagnostic with AI" },
                        { "<leader>sd", function() require("wtf").search() end, desc = "Search Diagnostic with Google" },
                },
        },
        {
                'echasnovski/mini.nvim',
                version = '*',
        },
        { 'echasnovski/mini.animate', version = '*' },
        {
                'RRethy/vim-illuminate',
                event = 'VeryLazy', -- BufReadが最適だがバランス的にVeryLazyの方がいい
                config = function()
                        require('illuminate').configure {
                                delay = 300,
                                modes_denylist = { 'i' },
                                filetypes_denylist = {
                                        'aerial',
                                        'NvimTree',
                                        'notify',
                                        'markdown',
                                },
                        }
                end,
        },
        {
                'yamatsum/nvim-cursorline',
                dependencies = { 'tpope/vim-repeat' },
                config = function()
                        require('nvim-cursorline').setup {}
                end,
        },
        'chrisbra/csv.vim',
        { 'jdhao/whitespace.nvim',    event = 'BufEnter' },
        -- "rcarriga/nvim-dap-ui",
        {
                'ggandor/leap.nvim',
                enabled = false,
                keys = {
                        { 's', mode = { 'n', 'x', 'o' }, desc = 'Leap Forward to' },
                        { 'S', mode = { 'n', 'x', 'o' }, desc = 'Leap Backward to' },
                        -- { "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
                },
                config = function(_, opts)
                        local leap = require 'leap'
                        for k, v in pairs(opts) do
                                leap.opts[k] = v
                        end
                        leap.add_default_mappings(true)
                        vim.keymap.del({ 'x', 'o' }, 'x')
                        vim.keymap.del({ 'x', 'o' }, 'X')
                        vim.keymap.del({ 'n', 'v', 'x', 'o' }, 'gs')
                end,
        },

        -- {
        -- 	"jay-babu/mason-nvim-dap.nvim",
        -- 	dependencies = {
        -- 		"mfussenegger/nvim-dap",
        -- 		"williamboman/mason.nvim",
        -- 	},
        -- 	opts = {
        -- 		handlers = {
        -- 			ensure_installed = {
        -- 				"codelldb",
        -- 			},
        -- 		},
        -- 	},
        -- },
        -- "theHamsta/nvim-dap-virtual-text",
        -- { "mfussenegger/nvim-dap-python" },
        -- "nvim-telescope/telescope-dap.nvim",
        { 'jbyuki/one-small-step-for-vimkind', module = 'osv' },
        -- { "mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" } },
        'nvim-lua/popup.nvim',
        { 'j-hui/fidget.nvim',                 tag = 'legacy' },
        'lunarvim/darkplus.nvim',
        { 'nanotee/zoxide.vim' },
        {
                'axkirillov/hbac.nvim',
                event = 'VeryLazy',
                opts = {
                        autoclose = true,
                        threshold = 10,
                },
        },
        { 'svrana/neosolarized.nvim' },
        -- {
        -- 	"Zeioth/dooku.nvim",
        -- 	cmd = { "DookuGenerate", "DookuOpen", "DookuAutoSetup" },
        -- 	opts = {},
        -- },
        {
                'mvllow/modes.nvim',
                tag = 'v0.2.0',
                config = function()
                        require('modes').setup {
                                colors = {
                                        insert = '#00ff00',
                                        normal = '#0000ff',
                                        replace = '#ff0000',
                                        visual = '#ff00ff',
                                },
                        }
                end,
        },
        {
                'roobert/tailwindcss-colorizer-cmp.nvim',
                -- optionally, override the default options:
                config = function()
                        require('tailwindcss-colorizer-cmp').setup {
                                color_square_width = 2,
                        }

                        require('cmp').config.formatting = {
                                format = require('tailwindcss-colorizer-cmp').formatter,
                        }
                end,
        },
        { 'HiPhish/rainbow-delimiters.nvim' },
        { 'honza/vim-snippets' },
        {
                'iamcco/markdown-preview.nvim',
                cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
                keys = {
                        {
                                '<leader>mp',
                                function()
                                        vim.cmd 'MarkdownPreviewToggle'
                                end,
                                desc = 'Toggle',
                        },
                },
                ft = { 'markdown' },
                build = function()
                        vim.fn['mkdp#util#install']()
                end,
        },
}
require('lazy').setup({
        { import = 'plugins' },
        { import = 'plugins.lsp' },
        lazy_plugins,
}, {
        ui = {
                border = 'shadow',
                custom_keys = {
                        ['<leader>ll'] = function(plugin)
                                require('lazy.util').float_term({ 'lazygit', 'log' }, {
                                        cwd = plugin.dir,
                                })
                        end,
                },
        },
        dev = {
                path = '~/github',
        },
        install = {
                colorscheme = { 'darkplus' },
        },
})
