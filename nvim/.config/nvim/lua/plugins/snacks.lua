return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit Log (cwd)",
		},
		{
			"<leader>nh",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<Leader>nd",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
		{
			"<leader>gb",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
		},
		{
			"<leader>fR",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
		},
	},
	opts = {
		lazygit = { enabled = true },
		bigfile = { enabled = true },
		notifier = { enabled = true, timeout = 5000, style = "fancy", top_down = false },
		styles = {
			notification = {
				wo = { wrap = true }, -- Wrap notifications
			},
		},
	},
	config = function(_, opts)
		vim.api.nvim_create_user_command("Gbrowse", function()
			Snacks.gitbrowse()
		end, {})
		vim.api.nvim_create_user_command("Gitbranch", function()
			local gbok, gb = pcall(require, "snacks.gitbrowse")
			if not gbok then
				return
			end
			gb.open({ what = "branch" })
		end, { desc = "Open branch in origin git site" })

		vim.api.nvim_create_user_command("Gitrepo", function()
			local gbok, gb = pcall(require, "snacks.gitbrowse")
			if not gbok then
				return
			end
			gb.open({ what = "repo" })
		end, { desc = "Open repo root in origin git site" })
	end,
}
