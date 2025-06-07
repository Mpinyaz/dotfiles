return {
	cmd = { "cmake-language-server" },
	root_dir = function(fname)
		return util.root_pattern("CMakePresets.json", "CTestConfig.cmake", ".git", "build", "cmake")(fname)
	end,
	single_file_support = true,
	init_options = {
		buildDirectory = "build",
	},
	filetypes = { "cmake", "make" },
}
