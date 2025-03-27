-- vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
-- vim.opt.shortmess:append 'c'
--
-- return {
--         { 'rafamadriz/friendly-snippets' },
--         { 'AndreM222/copilot-lualine' },
--         {
--                 'David-Kunz/cmp-npm',
--                 dependencies = { 'nvim-lua/plenary.nvim' },
--                 ft = 'json',
--                 config = function()
--                         require('cmp-npm').setup {}
--                 end,
--         },
--         {
--                 'luckasRanarison/tailwind-tools.nvim',
--                 name = 'tailwind-tools',
--                 build = 'UpdateRemotePlugins',
--                 dependencies = {
--                         'nvim-treesitter/nvim-treesitter',
--                         'nvim-telescope/telescope.nvim', -- optional
--                         'neovim/nvim-lspconfig', -- optional
--                 },
--                 opts = {},             -- your configuration
--                 config = function()
--                         require('tailwind-tools').setup {
--                                 lsp = {
--                                         enabled = true,
--                                         debounce = 150,
--                                 },
--                                 telescope = {
--                                         enabled = true,
--                                 },
--                         }
--                 end,
--         },
--         {
--                 'hrsh7th/nvim-cmp',
--                 event = 'InsertEnter',
--                 dependencies = {
--                         'hrsh7th/cmp-nvim-lsp-signature-help',
--                         'hrsh7th/cmp-nvim-lsp',
--                         'hrsh7th/cmp-calc',
--                         'roobert/tailwindcss-colorizer-cmp.nvim',
--                         'lukas-reineke/cmp-rg',
--                         'luckasRanarison/tailwind-tools.nvim',
--                         'hrsh7th/cmp-buffer',
--                         'hrsh7th/cmp-path',
--                         'hrsh7th/cmp-cmdline',
--                         'windwp/nvim-autopairs',
--                         'saadparwaiz1/cmp_luasnip',
--                         'brenoprata10/nvim-highlight-colors',
--                         {
--                                 'L3MON4D3/LuaSnip',
--                                 version = '2.*',
--                                 dependencies = { 'rafamadriz/friendly-snippets' },
--                                 opts = function()
--                                         local types = require 'luasnip.util.types'
--                                         return {
--                                                 history = true,
--                                                 delete_check_events = 'TextChanged',
--
--                                                 ext_opts = {
--                                                         [types.insertNode] = {
--                                                                 unvisited = {
--                                                                         virt_text = { { '|', 'Conceal' } },
--                                                                         -- virt_text_pos = "inline",
--                                                                 },
--                                                         },
--                                                         [types.exitNode] = {
--                                                                 unvisited = {
--                                                                         virt_text = { { '|', 'Conceal' } },
--                                                                         -- virt_text_pos = "inline",
--                                                                 },
--                                                         },
--                                                 },
--                                         }
--                                 end,
--                         },
--                         {
--                                 'saecki/crates.nvim',
--                                 event = { 'BufRead Cargo.toml' },
--                                 tag = 'stable',
--                                 ft = { 'rust', 'toml' },
--                                 requires = { { 'nvim-lua/plenary.nvim' } },
--                                 config = function()
--                                         require('crates').setup {
--                                                 autoload = true,
--                                                 autoupdate = true,
--                                         }
--                                 end,
--                         },
--                         'hrsh7th/cmp-nvim-lua',
--                         'onsails/lspkind-nvim',
--                         {
--                                 'hrsh7th/cmp-emoji',
--                                 config = function()
--                                         require('cmp').setup {
--                                                 sources = {
--                                                         {
--                                                                 name = 'emoji',
--                                                         },
--                                                 },
--                                         }
--                                 end,
--                         },
--                 },
--                 config = function()
--                         local cmp = require 'cmp'
--                         local lsp_kind = require 'lspkind'
--                         local snip_status_ok, luasnip = pcall(require, 'luasnip')
--                         if not snip_status_ok then
--                                 return
--                         end
--
--                         local snippets = require 'luasnip.loaders.from_snipmate'
--                         snippets.load {
--                                 include = { vim.bo.filetype },
--                         }
--                         snippets.lazy_load()
--                         luasnip.config.set_config {
--                                 history = true,
--                                 region_check_events = 'InsertEnter',
--                                 updateevents = 'TextChanged,TextChangedI',
--                                 enable_autosnippets = true,
--                         }
--
--                         lsp_kind.init { mode = 'text_symbol', symbol_map = { Copilot = '' } }
--                         for _, ft_path in ipairs(vim.api.nvim_get_runtime_file('nvim/snippets/*.lua', true)) do
--                                 loadfile(ft_path)()
--                         end
--
--                         local has_words_before = function()
--                                 local unpack = unpack or table.unpack ---@diagnostic disable-line: deprecated
--                                 local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--                                 return col ~= 0 and
--                                 vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
--                         end
--                         local t = function(str)
--                                 return vim.api.nvim_replace_termcodes(str, true, true, true)
--                         end
--                         cmp.setup {
--                                 enabled = true,
--                                 preselect = cmp.PreselectMode.None,
--                                 view = {
--                                         entries = 'bordered',
--                                 },
--                                 completion = {
--                                         keyword_length = 1,
--                                         completeopt = 'menu,menuone,noinsert',
--                                 },
--                                 snippet = {
--                                         expand = function(args)
--                                                 luasnip.lsp_expand(args.body)
--                                         end,
--                                 },
--                                 mapping = {
--                                         ['<C-j>'] = cmp.mapping.scroll_docs(-4),
--                                         ['<C-k>'] = cmp.mapping.scroll_docs(4),
--                                         ['<C-Space>'] = cmp.mapping.complete(),
--                                         ['<C-e>'] = cmp.mapping.abort(),
--                                         ['<Tab>'] = cmp.mapping(function(fallback)
--                                                 if luasnip.expand_or_jumpable() then
--                                                         luasnip.expand_or_jump()
--                                                 else
--                                                         fallback()
--                                                 end
--                                         end, { 'i', 's' }),
--
--                                         ['<S-Tab>'] = cmp.mapping(function(fallback)
--                                                 if luasnip.jumpable(-1) then
--                                                         luasnip.jump(-1)
--                                                 else
--                                                         fallback()
--                                                 end
--                                         end, { 'i', 's' }),
--
--                                         ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
--                                         ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
--                                         ['<C-y>'] = cmp.mapping(
--                                                 cmp.mapping.confirm {
--                                                         behavior = cmp.ConfirmBehavior.Replace,
--                                                         select = true,
--                                                 },
--                                                 { 'i', 'c' }
--                                         ),
--                                 },
--                                 window = {
--                                         completion = cmp.config.window.bordered {
--                                                 winhighlight = 'Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None',
--                                         },
--                                         documentation = cmp.config.window.bordered {
--                                                 winhighlight = 'Normal:Normal,FloatBorder:LspBorderBG,CursorLine:PmenuSel,Search:None',
--                                         },
--                                 },
--                                 performance = {
--                                         trigger_debounce_time = 500,
--                                         throttle = 550,
--                                         fetching_timeout = 80,
--                                 },
--                                 formatting = {
--
--                                         format = function(entry, item)
--                                                 local color_item = require('nvim-highlight-colors').format(entry,
--                                                         { kind = item.kind })
--                                                 item = require('lspkind').cmp_format {
--                                                         mode = 'text_symbol',
--                                                         with_text = true,
--                                                         maxwidth = 50,
--                                                         ellipsis_char = '...',
--                                                         show_labelDetails = true,
--                                                 } (entry, item)
--                                                 if color_item.abbr_hl_group then
--                                                         item.kind_hl_group = color_item.abbr_hl_group
--                                                         item.kind = color_item.abbr
--                                                 end
--                                                 return item
--                                         end,
--                                 },
--                                 sources = {
--                                         {
--                                                 name = 'nvim_lsp',
--                                                 max_item_count = 20,
--                                                 group_index = 1,
--                                         },
--                                         {
--                                                 name = 'luasnip',
--                                                 max_item_count = 5,
--                                                 group_index = 1,
--                                         },
--                                         {
--                                                 name = 'vim-dadbod-completion',
--                                                 group_index = 1,
--                                         },
--                                         {
--                                                 name = 'path',
--                                                 group_index = 2,
--                                         },
--                                         {
--                                                 name = 'rg',
--                                                 keyword_length = 2,
--                                                 max_item_count = 5,
--                                                 group_index = 2,
--                                         },
--                                         {
--                                                 name = 'calc',
--                                                 keyword_length = 2,
--                                                 max_item_count = 5,
--                                                 group_index = 2,
--                                         },
--                                         {
--                                                 name = 'buffer',
--                                                 keyword_length = 2,
--                                                 max_item_count = 5,
--                                                 group_index = 2,
--                                         },
--                                         {
--                                                 name = 'treesitter',
--                                                 keyword_length = 2,
--                                                 max_item_count = 5,
--                                                 group_index = 2,
--                                         },
--                                         {
--                                                 name = 'lazydev',
--                                                 group_index = 0, -- set group index to 0 to skip loading LuaLS completions
--                                         },
--                                         {
--                                                 name = 'emoji',
--                                                 keyword_length = 2,
--                                                 max_item_count = 5,
--                                                 group_index = 2,
--                                         },
--                                         { name = 'npm',    keyword_length = 2, max_item_count = 5, group_index = 2 },
--                                         { name = 'crates', keyword_length = 2, max_item_count = 5, group_index = 2 },
--                                 },
--                         }
--                         local presentAutopairs, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
--                         if not presentAutopairs then
--                                 return
--                         end
--                         cmp.event:on(
--                                 'confirm_done',
--                                 cmp_autopairs.on_confirm_done {
--                                         map_char = {
--                                                 tex = '',
--                                         },
--                                 }
--                         )
--                         cmp.config.formatting = {
--                                 format = require('tailwindcss-colorizer-cmp').formatter,
--                         }
--
--                         cmp.setup.cmdline({ '/', '?' }, {
--                                 mapping = cmp.mapping.preset.cmdline(),
--                                 sources = {
--                                         { name = 'buffer' },
--                                 },
--                         })
--                         cmp.setup.filetype({ 'sql' }, {
--                                 sources = {
--                                         { name = 'vim-dadbod-completion' },
--                                         { name = 'buffer' },
--                                 },
--                         })
--                         cmp.setup.cmdline(':', {
--                                 mapping = cmp.mapping.preset.cmdline(),
--                                 sources = cmp.config.sources({
--                                         { name = 'path' },
--                                 }, {
--                                         { name = 'cmdline' },
--                                 }),
--                         })
--                 end,
--         },
-- }

local trigger_text = ";"

return {
	"saghen/blink.cmp",
	enabled = true,
	dependencies = {
		"moyiz/blink-emoji.nvim",
		"Kaiser-Yang/blink-cmp-dictionary",
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = function(_, opts)
		opts.enabled = function()
			-- Get the current buffer's filetype
			local filetype = vim.bo[0].filetype
			-- Disable for Telescope buffers
			if filetype == "TelescopePrompt" or filetype == "minifiles" or filetype == "snacks_picker_input" then
				return false
			end
			return true
		end

		-- NOTE: The new way to enable LuaSnip

		-- Merge custom sources with the existing ones from lazyvim
		-- NOTE: by default lazyvim already includes the lazydev source, so not adding it here again
		opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
			default = { "lsp", "path", "snippets", "buffer", "dadbod", "emoji" },
			providers = {
				lsp = {
					name = "lsp",
					enabled = true,
					module = "blink.cmp.sources.lsp",
					min_keyword_length = 2,
					score_offset = 90, -- the higher the number, the higher the priority
				},
				path = {
					name = "Path",
					module = "blink.cmp.sources.path",

					score_offset = 25,

					fallbacks = { "snippets", "buffer" },
					-- min_keyword_length = 2,
					opts = {
						trailing_slash = false,
						label_trailing_slash = true,
						get_cwd = function(context)
							return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
						end,
						show_hidden_files_by_default = true,
					},
				},
				buffer = {
					name = "Buffer",
					enabled = true,
					max_items = 3,
					module = "blink.cmp.sources.buffer",
					min_keyword_length = 4,
					score_offset = 15, -- the higher the number, the higher the priority
				},
				snippets = {
					name = "snippets",
					enabled = true,
					max_items = 15,
					min_keyword_length = 2,
					module = "blink.cmp.sources.snippets",
					score_offset = 85, -- the higher the number, the higher the priority
					-- Only show snippets if I type the trigger_text characters, so
					-- to expand the "bash" snippet, if the trigger_text is ";" I have to
					should_show_items = function()
						local col = vim.api.nvim_win_get_cursor(0)[2]
						local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
						-- NOTE: remember that `trigger_text` is modified at the top of the file
						return before_cursor:match(trigger_text .. "%w*$") ~= nil
					end,
					-- After accepting the completion, delete the trigger_text characters
					-- from the final inserted text
					-- Modified transform_items function based on suggestion by `synic` so
					-- that the luasnip source is not reloaded after each transformation
					-- https://github.com/linkarzu/dotfiles-latest/discussions/7#discussion-7849902
					-- NOTE: I also tried to add the ";" prefix to all of the snippets loaded from
					-- friendly-snippets in the luasnip.lua file, but I was unable to do
					-- so, so I still have to use the transform_items here
					-- This removes the ";" only for the friendly-snippets snippets
					transform_items = function(_, items)
						local line = vim.api.nvim_get_current_line()
						local col = vim.api.nvim_win_get_cursor(0)[2]
						local before_cursor = line:sub(1, col)
						local start_pos, end_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
						if start_pos then
							for _, item in ipairs(items) do
								if not item.trigger_text_modified then
									---@diagnostic disable-next-line: inject-field
									item.trigger_text_modified = true
									item.textEdit = {
										newText = item.insertText or item.label,
										range = {
											start = { line = vim.fn.line(".") - 1, character = start_pos - 1 },
											["end"] = { line = vim.fn.line(".") - 1, character = end_pos },
										},
									}
								end
							end
						end
						return items
					end,
				},
				-- Example on how to configure dadbod found in the main repo
				-- https://github.com/kristijanhusak/vim-dadbod-completion
				dadbod = {
					name = "Dadbod",
					module = "vim_dadbod_completion.blink",
					min_keyword_length = 2,
					score_offset = 85, -- the higher the number, the higher the priority
				},
				-- https://github.com/moyiz/blink-emoji.nvim
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 93, -- the higher the number, the higher the priority
					min_keyword_length = 2,
					opts = { insert = true }, -- Insert emoji (default) or complete its name
				},
			},
		})

		opts.cmdline = {
			enabled = true,
		}
		opts.signature = { window = { border = "single" } }

		opts.completion = {
			menu = {
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								local lspkind = require("lspkind")
								local icon = ctx.kind_icon
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon = require("lspkind").symbolic(ctx.kind, {
										mode = "symbol",
									})
								end

								return icon .. ctx.icon_gap
							end,

							-- Optionally, use the highlight groups from nvim-web-devicons
							-- You can also add the same function for `kind.highlight` if you want to
							-- keep the highlight groups in sync with the icons.
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
					},
				},
			},

			documentation = {
				auto_show = true,
				window = {
					border = "single",
				},
			},
			-- Displays a preview of the selected item on the current line
			ghost_text = {
				enabled = true,
			},
		}

		opts.snippets = {
			preset = "luasnip", -- Choose LuaSnip as the snippet engine
		}
		opts.keymap = {
			preset = "default",
			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },

			["<S-k>"] = { "scroll_documentation_up", "fallback" },
			["<S-j>"] = { "scroll_documentation_down", "fallback" },

			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
		}

		return opts
	end,
}
