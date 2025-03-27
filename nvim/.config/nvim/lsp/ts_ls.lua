---@type vim.lsp.Config
return {
	cmd = { "typescript-language-server", "--stdio" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	on_attach = on_attach,
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},

	settings = {
		completions = {
			completeFunctionCalls = true,
		},
	},
	javascript = {
		inlayHints = {
			includeInlayEnumMemberValueHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayVariableTypeHints = true,
		},
	},
	typescript = {
		inlayHints = {
			includeInlayEnumMemberValueHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayVariableTypeHints = true,
		},
	},
}
