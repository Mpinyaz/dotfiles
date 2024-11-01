return {
	"windwp/nvim-ts-autotag",
	event = "VimEnter",
	opts = {
		enable_close = true, -- Auto close tags
		enable_rename = true, -- Auto rename pairs of tags
		enable_close_on_slash = false,
	},
	config = function()
		require("nvim-ts-autotag").setup({})
	end,
}
