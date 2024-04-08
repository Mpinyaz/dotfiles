return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	requires = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local logo = [[
███╗   ███╗██████╗ ██╗███╗   ██╗██╗   ██╗ █████╗ ███████╗
████╗ ████║██╔══██╗██║████╗  ██║╚██╗ ██╔╝██╔══██╗╚══███╔╝
██╔████╔██║██████╔╝██║██╔██╗ ██║ ╚████╔╝ ███████║  ███╔╝
██║╚██╔╝██║██╔═══╝ ██║██║╚██╗██║  ╚██╔╝  ██╔══██║ ███╔╝
██║ ╚═╝ ██║██║     ██║██║ ╚████║   ██║   ██║  ██║███████╗
╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝
      ]]

		logo = string.rep("\n", 8) .. logo .. "\n\n"
		require("dashboard").setup({
			theme = "doom",
			config = {
				header = vim.split(logo, "\n"),
				footer = { "🎉 Exiting Neovim is a life skill!" },
				center = {
					{
						icon = "  ",
						desc = "Find recent files                       ",
						action = "Telescope oldfiles",
						shortcut = "SPC f r",
					},
					{
						icon = "  ",
						desc = "Find files                              ",
						action = "Telescope find_files find_command=rg,--hidden,--files",
						shortcut = "SPC f f",
					},
					{
						icon = "  ",
						desc = "File browser                            ",
						action = "Telescope file_browser",
						shortcut = "SPC f b",
					},
					{
						icon = "  ",
						desc = "Find word                               ",
						action = "Telescope live_grep",
						shortcut = "SPC f w",
					},
					{
						icon = "  ",
						desc = "Load new theme                          ",
						action = "Telescope colorscheme",
						shortcut = "SPC h t",
					},
				},
			},
		})
	end,
}
