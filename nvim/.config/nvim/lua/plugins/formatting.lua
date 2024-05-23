return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	keys = {
		{
			"<leader>Cf",
			function()
				require("conform").format({ formatters = { "injected" } })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
	},
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				svelte = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				graphql = { "prettierd" },
				lua = { "stylua" },
				rust = { "rustfmt" },
				python = { "isort", "black" },
				fish = { "fish_indent" },
				sh = { "shfmt" },
				toml = { "taplo" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
-- return {
--         "nvimtools/none-ls.nvim",
--         config = function()
--                 local null_ls = require("null-ls")
--                 local null_ls_status_ok, nls = pcall(require, "null-ls")
--                 if not null_ls_status_ok then
--                         return
--                 end
--
--                 local nls_utils = require("null-ls.utils")
--                 local b = nls.builtins
--
--                 null_ls.setup({
--                         root_dir = nls_utils.root_pattern(".git"),
--                         save_after_format = true,
--                         sources = {
--                                 -- formatting
--                                 b.formatting.prettierd,
--                                 -- b.formatting.eslint_d.with({ extra_filetypes = { "astro" } }),
--                                 -- b.formatting.trim_newlines,
--                                 -- b.formatting.standardjs,
--                                 b.formatting.shfmt.with({ filetypes = { "sh", "bash", "zsh" } }),
--                                 b.formatting.stylua,
--                                 -- b.formatting.prettier,
--                                 -- b.formatting.fixjson,
--                                 b.formatting.tidy,
--                                 b.formatting.leptosfmt,
--                                 -- b.formatting.rustywind,
--                                 b.formatting.clang_format,
--                                 b.formatting.black.with({ extra_args = { "--fast" } }),
--                                 b.diagnostics.yamllint,
--                                 b.formatting.yamlfix,
--                                 b.formatting.sqlfmt,
--                                 b.diagnostics.sqlfluff,
--                         },
--                 })
--
--                 vim.keymap.set("n", "<leader>qf", vim.lsp.buf.format, {})
--         end,
-- }
