---@type vim.lsp.Config
return {
	-- Have to add this for yamlls to understand that we support line folding
	capabilities = { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } },
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			schemas = require("schemastore").yaml.schemas(),
			keyOrdering = false,
			format = { enable = true },
			validate = true,
			schemaStore = {
				--Must disable built-in schemaStore support to use schemas from SchemaStore.nvim plugin
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = "",
			},
		},
	},
}
