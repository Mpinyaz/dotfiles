return {
	"L3MON4D3/LuaSnip",
	opts = {
		history = true, -- keep around last snippet local to jump back
		updateevents = "TextChanged,TextChangedI", -- update changes as you type
		enable_autosnippets = true,
	},
	config = function()
		local ls = require("luasnip")

		-- For linux
		require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

		-- For windows
		-- require("luasnip.loaders.from_lua").load({ paths = "~/Appdata/Local/nvim/snippets/" })

		require("utils.luasnip").luasnip(opts)
	end,
}
