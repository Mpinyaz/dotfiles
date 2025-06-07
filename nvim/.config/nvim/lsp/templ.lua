vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

return {
	cmd = { "templ", "lsp" },
	root_markers = { "go.work", "go.mod", ".git" },
	capabilities = capabilities,
	on_init = on_init,
	filetypes = { "templ" },
}
