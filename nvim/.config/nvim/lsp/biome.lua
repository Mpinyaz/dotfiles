---@type vim.lsp.Config
return {
	cmd = { "npx", "biome", "lsp-proxy" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
}
