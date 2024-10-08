return function(on_attach)
	return {
		cmd = { "clangd", "--offset-encoding=utf-16" },
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
end
