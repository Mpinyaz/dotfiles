return {
	cmd = {
		"clangd",
		"--offset-encoding=utf-16",
		"--background-index",
		"--suggest-missing-includes",
		"--clang-tidy",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--header-insertion=iwyu",
	},
	root_markers = { ".clangd", ".clang-format", "compile_commands.json", "compile_flags.txt" },
	filetypes = { "c", "cpp" },
	init_options = {
		clangdFileStatus = true,
		usePlaceholders = true,
		completeUnimported = true,
		semanticHighlighting = true,
	},
	settings = {
		clangd = {
			InlayHints = {
				Designators = true,
				Enabled = true,
				ParameterNames = true,
				DeducedTypes = true,
			},
			fallbackFlags = { "-std=c++20" },
		},
	},
}
