return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local function dir_exists(path)
			local stat = vim.loop.fs_stat(path)
			return stat and stat.type == "directory"
		end

		-- Define potential workspaces
		local potential_workspaces = {
			{
				name = "Notes",
				path = "/Users/eltonmpinyuri/Documents/Obsidian Vault/",
			},
			{
				name = "Work",
				path = "/Users/eltonmpinyuri/Documents/Work Vault/",
			},
			{
				name = "Personal",
				path = "/home/mpinyaz/Documents/Obsidian Vault/",
			},
		}

		-- Only add workspaces that exist
		local workspaces = {}
		for _, workspace in ipairs(potential_workspaces) do
			local expanded_path = vim.fn.expand(workspace.path)
			if dir_exists(expanded_path) then
				table.insert(workspaces, {
					name = workspace.name,
					path = expanded_path,
				})
			end
		end

		require("obsidian").setup({
			workspaces = workspaces,
			-- Add other obsidian settings here
		})
	end,
}
