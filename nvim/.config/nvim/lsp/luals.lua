return {
	cmd = { "lua-language-server" },
	root_markers = { ".luarc.json", ".git", ".stylua" },
	settings = {
		Lua = {
			hint = {
				enable = true,
			},
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
				disable = {
					"lowercase-global",
					"undefined-global",
					"unused-local",
					"unused-vararg",
					"trailing-space",
				},
			},
			workspace = {
				-- make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
			-- do not send telemetry data containing a randomized but unique identifier
			telemetry = { enable = false },
			completion = {
				callSnippet = "Both",
			},
		},
	},
	filetypes = { "lua" },
}
