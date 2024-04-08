local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
        -- bootstrap lazy.nvim
        -- stylua: ignore
        vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                lazypath })
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
local lazy_plugins = {
	{
		"b0o/incline.nvim",
		dependencies = { "craftzdog/solarized-osaka.nvim" },
		event = "BufReadPre",
		priority = 1200,
		config = function()
			local colors = require("solarized-osaka.colors").setup()
			require("incline").setup({
				highlight = {
					groups = {
						InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
						InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
					},
				},
				window = { margin = { vertical = 0, horizontal = 1 } },
				hide = {
					cursorline = true,
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
					if vim.bo[props.buf].modified then
						filename = "[+] " .. filename
					end

					local icon, color = require("nvim-web-devicons").get_icon_color(filename)
					return { { icon, guifg = color }, { " " }, { filename } }
				end,
			})
		end,
	},
	-- {
	-- 	"echasnovski/mini.animate",
	-- 	version = "*",
	-- 	-- event = "VeryLazy",
	-- },
	{ "gbprod/yanky.nvim" },
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({})
		end,
	},
	{
		"tzachar/highlight-undo.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"piersolenski/wtf.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {},
                --stylua: ignore
                keys = {
                        { "<leader>sD", function() require("wtf").ai() end,     desc = "Search Diagnostic with AI" },
                        { "<leader>sd", function() require("wtf").search() end, desc = "Search Diagnostic with Google" },
                },
	},
	{
		"echasnovski/mini.nvim",
		version = "*",
	},
	{
		"yamatsum/nvim-cursorline",
		config = function()
			require("nvim-cursorline").setup({})
		end,
	},
	{ "jdhao/whitespace.nvim", event = "VimEnter" },
	"rcarriga/nvim-dap-ui",
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
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
	-- "nvim-telescope/telescope-dap.nvim",
	{ "jbyuki/one-small-step-for-vimkind", module = "osv" },
	-- { "mxsdev/nvim-dap-vscode-js", dependencies = { "mfussenegger/nvim-dap" } },
	-- { "mfussenegger/nvim-dap-python" },
	"nvim-lua/popup.nvim",
	{ "j-hui/fidget.nvim", tag = "legacy" },
	"lunarvim/darkplus.nvim",
	{ "nanotee/zoxide.vim" },
	{
		"tiagovla/scope.nvim",
		event = "VeryLazy",
		opts = {},
		config = function()
			require("scope").setup({
				position = "top",
				size = 0.5,
				sort = "ascending",
				preview = {
					position = "right",
					size = 0.5,
				},
			})
		end,
	},

	{
		"axkirillov/hbac.nvim",
		event = "VeryLazy",
		opts = {
			autoclose = true,
			threshold = 10,
		},
	},
	{ "edeneast/nightfox.nvim" },
	{ "svrana/neosolarized.nvim" },
	-- {
	-- 	"Zeioth/dooku.nvim",
	-- 	cmd = { "DookuGenerate", "DookuOpen", "DookuAutoSetup" },
	-- 	opts = {},
	-- },
	{
		"mvllow/modes.nvim",
		tag = "v0.2.0",
		config = function()
			require("modes").setup({
				colors = {
					insert = "#00ff00",
					normal = "#0000ff",
					replace = "#ff0000",
					visual = "#ff00ff",
				},
			})
		end,
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		-- optionally, override the default options:
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})

			require("cmp").config.formatting = {
				format = require("tailwindcss-colorizer-cmp").formatter,
			}
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	-- {
	-- 	"luckasRanarison/nvim-devdocs",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	opts = {},
	-- 	cmd = {
	-- 		"DevdocsFetch",
	-- 		"DevdocsInstall",
	-- 		"DevdocsUninstall",
	-- 		"DevdocsOpen",
	-- 		"DevdocsOpenFloat",
	-- 		"DevdocsOpenCurrent",
	-- 		"DevdocsOpenCurrentFloat",
	-- 		"DevdocsUpdate",
	-- 		"DevdocsUpdateAll",
	-- 	},
	-- 	config = function()
	-- 		require("nvim-devdocs").setup()
	-- 	end,
	-- },
	{ "HiPhish/rainbow-delimiters.nvim" },
	{
		"ThePrimeagen/git-worktree.nvim",
		opts = {},
		config = function()
			require("telescope").load_extension("git_worktree")
		end,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
                --stylua: ignore
                keys = {
                        { "<leader>gwm", function() require("telescope").extensions.git_worktree.git_worktrees() end,       desc = "Manage" },
                        { "<leader>gwc", function() require("telescope").extensions.git_worktree.create_git_worktree() end, desc = "Create" },
                },
	},
}
require("lazy").setup({
	{ import = "plugins" },
	{ import = "plugins.lsp" },
	lazy_plugins,
}, {
	ui = {
		border = "shadow",
		custom_keys = {
			["<leader>ll"] = function(plugin)
				require("lazy.util").float_term({ "lazygit", "log" }, {
					cwd = plugin.dir,
				})
			end,
		},
	},
	dev = {
		path = "~/github",
	},
	install = {
		colorscheme = { "darkplus" },
	},
})