return {
	cmd = { "htmx-lsp" },
	capabilities = capabilities,
	on_init = on_init,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"templ",
		"html",
	},
	single_file_support = true,
	-- root_dir = function(fname)
	-- 	return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
	-- end,
}
