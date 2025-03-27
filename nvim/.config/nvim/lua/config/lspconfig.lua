local servers = {
	"pyright",
	"bashls",
	"gopls",
	"cmake",
	"omnisharp",
	"biome",
	"vimls",
	"lua_ls",
	"html",
	"jsonls",
	"cssls",
	"tailwindcss",
	"clangd",
	"taplo",
	"lua-language-server",
	"markdown_oxide",
	"yamlls",
}

----------------------------------------------------------------------
--                        LSP Client attach                         --
----------------------------------------------------------------------
local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
	textDocument = {
		foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
		completion = {
			completionItem = {
				-- documentationFormat = { "markdown", "plaintext" },
				snippetSupport = true,
				preselectSupport = true,
				insertReplaceSupport = true,
				labelDetailsSupport = true,
				deprecatedSupport = true,
				commitCharactersSupport = true,
				tagSupport = { valueSet = { 1 } },
				resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
					},
				},
			},
		},
	},
})

local function on_init(client, result)
	client.server_capabilities = vim.tbl_deep_extend("force", client.server_capabilities, capabilities)

	-- Set empty trigger characters for signatureHelp if supported
	if client.supports_method("textDocument/signatureHelp") then
		client.server_capabilities.signatureHelpProvider.triggerCharacters = {}
	end

	-- Handle off-spec "offsetEncoding" server capability
	if result.offsetEncoding then
		client.offset_encoding = result.offsetEncoding
	end
end

vim.lsp.config("*", { on_init = on_init })
vim.lsp.enable(servers, vim.g.lsp and vim.g.lsp.autostart or true)

-- Create an augroup for LSP-related autocommands
vim.api.nvim_create_augroup("lsp", { clear = true })
local telescope_ok, telescope = pcall(require, "telescope.builtin")

-- Wrapper for keymapping with default opts
local map = function(mode, lhs, rhs, desc)
	local opts = {
		noremap = true,
		silent = true,
		desc = "LSP: " .. desc,
	}
	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.api.nvim_create_augroup("lsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = "lsp",
	callback = function(args)
		local bufnr = args.buf
		local client_id = args.data.client_id
		local client = vim.lsp.get_client_by_id(client_id)

		local function buf_set_keymap(...)
			vim.api.nvim_buf_set_keymap(bufnr, ...)
		end
		local opts = { noremap = true, silent = true }
		-- Store LSP client name in buffer-local variable
		vim.b[bufnr].lsp = client.name
		-- Mappings
		-- See `:help vim.diagnostic.*` for documentation on any of the below functions
		map("n", "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", "Go to next diagnostic")
		map("n", "ge", "<Cmd>Lspsaga show_line_diagnostic<CR>", "Show diagnostics of the current line")
		map("n", "gd", "<Cmd>Lspsaga peek_definition<CR>", "Show diagnostics of the current line")
		map("n", "gr", "<Cmd>Lspsaga rename ++projects<CR>", "Rename variable under cursor")
		map("n", "<leader>ca", "<Cmd>Lspsaga code_action<CR>", "Code actions")
		map("n", "gf", "<Cmd>Lspsaga finder<CR>", "Find references and implementation under cursor")
		map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Show hover doc")
		map("n", "go", "<cmd>Lspsaga outline<CR>", "Show Lsp outline")
		map("n", "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "Go to the previous diagnostic")
		map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Show hover doc")
		if telescope_ok then
			map("n", "<leader>d", telescope.diagnostics, "Show all diagnostics")
		else
			map("n", "<leader>E", function()
				vim.diagnostic.setloclist()
			end, "Show all diagnostics")
		end

		if client.server_capabilities.documentFormattingProvider then
			buf_set_keymap("n", "<leader>Cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
		end
		-- if client.server_capabilities.inlayHintProvider then
		-- 	require("inlay-hints").on_attach(client, bufnr)
		-- end
		if client.server_capabilities.documentRangeFormattingProvider then
			buf_set_keymap("v", "<leader>cf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
		end

		if client.server_capabilities["documentSymbolProvider"] then
			require("nvim-navic").attach(client, bufnr)
		end
		if client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
			vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
			vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
				desc = "Highlight references under the cursor",
				buffer = bufnr,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
				desc = "Clear highlight references",
				buffer = bufnr,
				callback = vim.lsp.buf.clear_references,
			})
		end

		if not client.server_capabilities.semanticTokensProvider then
			local semantic = client.config.capabilities.textDocument.semanticTokens
			client.server_capabilities.semanticTokensProvider = {
				full = true,
				legend = {
					tokenTypes = semantic.tokenTypes,
					tokenModifiers = semantic.tokenModifiers,
				},
				range = true,
			}
		end

		-- Document highlight
		if client.supports_method("textDocument/documentHighlight") then
			vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
				group = "lsp",
				buffer = bufnr,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
				group = "lsp",
				buffer = bufnr,
				callback = vim.lsp.buf.clear_references,
			})
		end

		-- Inlay hints toggle
		if client.supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
		end

		-- Code lens
		if client.supports_method("textDocument/codeLens") then
			vim.api.nvim_create_autocmd("LspProgress", {
				group = "lsp",
				pattern = "end",
				callback = function(progress_args)
					if progress_args.buf == bufnr then
						vim.lsp.codelens.refresh({ bufnr = bufnr })
					end
				end,
			})

			vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
				group = "lsp",
				buffer = bufnr,
				callback = function()
					vim.lsp.codelens.refresh({ bufnr = bufnr })
				end,
			})

			vim.lsp.codelens.refresh({ bufnr = bufnr })
		end

		-- Folding
		-- if client.supports_method("textDocument/foldingRange") then
		-- 	vim.wo.foldmethod = "expr"
		-- vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
		-- end

		-- Formatting
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = "lsp",
				buffer = bufnr,
				callback = function()
					local autoformat = vim.F.if_nil(
						client.settings.autoformat,
						vim.b[bufnr].lsp and vim.b[bufnr].lsp.autoformat,
						vim.g.lsp and vim.g.lsp.autoformat,
						false
					)

					if autoformat then
						vim.lsp.buf.format({ bufnr = bufnr, id = client_id })
					end
				end,
			})
		end

		-- Completion
		if client.supports_method("textDocument/completion") then
			if client.name == "lua-language-server" then
				client.server_capabilities.completionProvider.triggerCharacters = { ".", ":" }
			end
			vim.lsp.completion.enable(true, client_id, bufnr, { autotrigger = true })
		end
	end,
})

----------------------------------------------------------------------
--                         Lsp Diagnostics                          --
----------------------------------------------------------------------
--
local icons = require("utils.icons")

local signs = {
	{
		name = "DiagnosticSignError",
		text = icons.diagnostics.error,
	},
	{
		name = "DiagnosticSignWarn",
		text = icons.diagnostics.warning,
	},
	{
		name = "DiagnosticSignHint",
		text = icons.diagnostics.hint,
	},
	{
		name = "DiagnosticSignInfo",
		text = icons.diagnostics.information,
	},
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, {
		texthl = sign.name,
		text = sign.text,
		numhl = "",
	})
end

local config = {
	-- virtual_text = true, -- appears after the line
	virtual_lines = true, -- appears under the line
	signs = {
		active = signs,
	},
	flags = {
		debounce_text_changes = 200,
		allow_incremental_sync = true,
	},
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focus = false,
		focusable = false,
		style = "minimal",
		border = "shadow",
		source = "always",
		header = "",
		prefix = "",
	},
}

vim.diagnostic.config(config)

local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	return
end

mason.setup({
	ensure_installed = servers,
	automatic_installation = true,
	ui = {
		border = "shadow",
		icons = require("utils.icons").mason,
		check_outdated_packages_on_open = true,
	},
})

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if mason_lspconfig_ok then
	mason_lspconfig.setup({
		ensure_installed = vim.tbl_deep_extend("force", servers),
		automatic_installation = true,
		ui = {
			border = "shadow",
			icons = require("utils.icons").mason,
			check_outdated_packages_on_open = true,
		},
	})
end
