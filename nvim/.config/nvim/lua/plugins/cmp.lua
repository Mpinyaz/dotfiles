vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

return {
	-- {
	-- 	"github/copilot.vim",
	-- 	event = "BufRead",
	-- 	config = function()
	-- 		vim.cmd([[imap <silent><script><expr> <C-a> copilot#Accept("\<CR>")]])
	-- 		vim.cmd([[imap <silent><script><expr> <C-e> copilot#Cancel("\<CR>")]])
	-- 		vim.g.copilot_no_tab_map = true
	-- 		vim.cmd([[highlight CopilotSuggestion guifg=#555555 ctermfg=8]])
	-- 		vim.api.nvim_command("highlight link CopilotAnnotation LineNr")
	-- 		vim.api.nvim_command("highlight link CopilotSuggestion LineNr")
	-- 	end,
	-- },

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = true },
				panel = { enabled = true },
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

						-- Display a cursor-like placeholder in unvisited nodes of the snippet.
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
			"windwp/nvim-autopairs",
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
			local cmp_next = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif require("luasnip").expand_or_jumpable() then
					vim.fn.feedkeys(
						vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
						""
					)
					-- elseif require("copilot.suggestion").is_visible() then
					-- 	require("copilot.suggestion").accept()
				elseif require("luasnip").expandable() then
					require("luasnip").expand()
				elseif check_backspace() then
					fallback()
				else
					fallback()
				end
			end
			local cmp_prev = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif require("luasnip").jumpable(-1) then
					vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
				else
					fallback()
				end
			end
			local function get_lsp_completion_context(completion, source)
				local config_ok, source_name = pcall(function()
					return source.source.client.config.name
				end)
				if not config_ok then
					return nil
				end
				if source_name == "tsserver" or source_name == "typescript-tools" then
					return completion.detail
				elseif source_name == "pyright" then
					if completion.labelDetails ~= nil then
						return completion.labelDetails.description
					end
				end
			end

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
				-- minimal increase in priority
				enable_autosnippets = true,
			})

			lsp_kind.init({ symbol_map = { Copilot = "" } })

			---@diagnostic disable-next-line
			cmp.setup({
				enabled = true,
				preselect = cmp.PreselectMode.None,
				window = {
					completion = cmp.config.window.bordered({
						winhighlight = "Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None",
					}),
					documentation = cmp.config.window.bordered({
						winhighlight = "Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None",
					}),
				},
				---@diagnostic disable-next-line
				view = {
					entries = "bordered",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<tab>"] = cmp_next,
					-- ["<down>"] = cmp_next,
					["<S-tab>"] = cmp_prev,
					-- ["<up>"] = cmp_prev,
				},
				formatting = {
					format = lsp_kind.cmp_format({
						with_text = true,
						menu = {

							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							copilot = "[Copilot]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[NeovimLua]",
							path = "[Path]",
							omni = "[Omni]",
							spell = "[Spell]",
							emoji = "[Emoji]",
							calc = "[Calc]",
							rg = "[Rg]",
							treesitter = "[TS]",
							dictionary = "[Dictionary]",
							npm = "[NPM]",
							tailwindcss_colorizer_cmp = "[Tailwind]",
						},
					}),
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
						name = "nvim_lua",
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
					{ name = "npm", keyword_length = 2, max_item_count = 5, group_index = 2 },
					{ name = "crates", keyword_length = 2, max_item_count = 5, group_index = 2 },
				},
			})
			local presentAutopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
			if not presentAutopairs then
				return
			end
			-- cmp.event:on(
			-- 	"confirm_done",
			-- 	cmp_autopairs.on_confirm_done({
			-- 		map_char = {
			-- 			tex = "",
			-- 		},
			-- 	})
			-- )
			cmp.config.formatting = {
				format = require("tailwindcss-colorizer-cmp").formatter,
			}

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
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
			-- cmp.filetype({ "sql" }, { sources = { { name = "vim-dadbod-completion" }, { name = "buffer" } } })
		end,
	},
}
