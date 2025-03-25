return {
	"mfussenegger/nvim-lint",
	lazy = true,
	opts = {
		linters = {
			["markdownlint-cli2"] = { args = { "--config", os.getenv("HOME") .. ".markdownlint.yaml", "--" } },
			eslint_d = {
				args = {
					"--no-warn-ignored",
					"--format",
					"json",
					"--stdin",
					"--stdin-filename",
					function()
						return vim.api.nvim_buf_get_name(0)
					end,
				},
			},
		},
	},
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			markdown = { "markdownlint" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint" },
			lua = { "luacheck" },
			zsh = { "zsh" },
			sh = { "shellcheck" },
			stylelint = { "stylelint" },
		}
		lint.linters.luacheck = {
			cmd = "luacheck",
			stdin = true,
			args = {
				"--globals",
				"vim",
				"lvim",
				"reload",
				"--",
			},
			stream = "stdout",
			ignore_exitcode = true,
			parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
				source = "luacheck",
			}),
		}
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>ql", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
