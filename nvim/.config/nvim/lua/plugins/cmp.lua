vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.shortmess:append("c")
local winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel"
return {
	"saghen/blink.cmp",
	version = "1.*",
	enabled = true,
	dependencies = {
		{
			"saghen/blink.compat",
			version = "*",
			lazy = true,
			opts = {},
		},
		"moyiz/blink-emoji.nvim",
		"philosofonusus/ecolog.nvim",

		"Kaiser-Yang/blink-cmp-dictionary",
		{ "mikavilpas/blink-ripgrep.nvim", lazy = true },
		{ "onsails/lspkind.nvim", lazy = true },
		{ "rafamadriz/friendly-snippets", lazy = true },
		{
			"David-Kunz/cmp-npm",
			event = "BufRead package.json",
			opts = {},
		},
		"nvim-tree/nvim-web-devicons",
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
					completion = {
						cmp = {
							enabled = true,
						},
						crates = {
							enabled = true,
						},
					},
				})
			end,
		},
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
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
			config = function()
				local snip_status_ok, luasnip = pcall(require, "luasnip")
				if not snip_status_ok then
					return
				end

				local snippets = require("luasnip.loaders.from_snipmate")
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

				for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("nvim/snippets/*.lua", true)) do
					loadfile(ft_path)()
				end
			end,
		},
		{
			"xzbdmw/colorful-menu.nvim",
			config = function()
				require("colorful-menu").setup({})
			end,
		},
	},
	opts = function(_, opts)
		---@module "blink.cmp"
		---@param ctx blink.cmp.Context
		---@param items blink.cmp.CompletionItem[]
		---@return blink.cmp.CompletionItem[]
		local function transform_items_capitalization(ctx, items)
			local keyword = ctx.get_keyword()
			local correct, case
			if keyword:match("^%l") then
				correct = "^%u%l+$"
				case = string.lower
			elseif keyword:match("^%u") then
				correct = "^%l+$"
				case = string.upper
			else
				return items
			end

			local seen = {}
			local out = {}
			for _, item in ipairs(items) do
				local insertText = item.insertText
				if insertText ~= nil then
					if insertText:match(correct) then
						local text = case(insertText:sub(1, 1)) .. insertText:sub(2)
						item.insertText = text
						item.label = text
					elseif not seen[insertText] then
						seen[insertText] = true
						table.insert(out, item)
					end
				end
			end

			return out
		end

		---@module "blink.cmp"
		---@param _ctx blink.cmp.Context
		---@param items blink.cmp.CompletionItem[]
		---@param label string
		---@return blink.cmp.CompletionItem[]
		---@diagnostic disable-next-line: unused-local
		local function transform_items_label(_ctx, items, label)
			for _, item in ipairs(items) do
				if label ~= nil then
					item.labelDetails = { description = "(" .. label .. ")" }
				end
			end

			return items
		end
		opts.enabled = function()
			-- Get the current buffer's filetype
			local filetype = vim.bo[0].filetype
			-- Disable for Telescope buffers
			if filetype == "TelescopePrompt" or filetype == "minifiles" or filetype == "snacks_picker_input" then
				return false
			end
			return true
		end
		opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
			default = { "lsp", "snippets", "path", "buffer", "emoji", "lazydev", "ripgrep", "crates", "npm", "ecolog" },
			per_filetype = { sql = { "dadbod" } },
			providers = {
				crates = {
					name = "crates",
					module = "blink.compat.source",
					score_offset = 5, -- the higher the number, the higher the priority
				},
				npm = {
					name = "npm",
					module = "blink.compat.source",
				},
				lsp = {
					name = "lsp",
					enabled = true,
					module = "blink.cmp.sources.lsp",
					min_keyword_length = 2,
					score_offset = 90, -- the higher the number, the higher the priority
				},
				ecolog = { name = "ecolog", module = "ecolog.integrations.cmp.blink_cmp" },
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
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
				buffer = {
					name = "Buffer",
					enabled = true,
					max_items = 3,
					module = "blink.cmp.sources.buffer",
					min_keyword_length = 4,
					score_offset = 15, -- the higher the number, the higher the priority
				},
				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",
					---@module "blink-ripgrep"
					---@type blink-ripgrep.Options
					opts = { prefix_min_len = 3 },
					async = true,
					transform_items = function(ctx, items)
						return transform_items_label(ctx, transform_items_capitalization(ctx, items), "rg")
					end,
					min_keyword_length = 3,
				},
				snippets = {
					name = "snippets",
					enabled = true,
					max_items = 15,
					min_keyword_length = 2,
					score_offset = 85, -- the higher the number, the higher the priority
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
		opts.signature = { enabled = true, window = { border = "single" } }
		opts.appearance = {
			use_nvim_cmp_as_default = true,
			nerd_font_variant = "mono",
		}

		opts.completion = {
			menu = {
				border = "rounded",
				draw = {
					treesitter = { "lsp" },
					columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								return require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
							end,
						},
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
						label_description = {
							text = function(ctx)
								if ctx.source_id == "lsp" then
									local label = require("colorful-menu").blink_highlights(ctx).label
									if
										label ~= ctx.label
										or label == ctx.label_description
										or ctx.label == ctx.label_description
									then
										return nil
									end
								end
								return ctx.label_description
							end,
						},
					},
				},
			},

			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = {
					border = "rounded",
				},
			},
			-- Displays a preview of the selected item on the current line
			ghost_text = {
				enabled = false,
			},
		}
		opts.fuzzy = { implementation = "prefer_rust_with_warning" }
		opts.snippets = {
			preset = "luasnip", -- Choose LuaSnip as the snippet engine
		}
		opts.keymap = {
			preset = "default",
			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			-- ["<C-p>"] = { "select_prev", "fallback" },
			-- ["<C-n>"] = { "select_next", "fallback" },

			["<S-k>"] = { "scroll_documentation_up", "fallback" },
			["<S-j>"] = { "scroll_documentation_down", "fallback" },

			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
		}

		return opts
	end,
}
