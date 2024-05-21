vim.loader.enable()
-- Automatically delete trailing newlines on file write
vim.cmd([[
 	autocmd BufWritePre * let currPos = getpos(".")
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e
 	autocmd BufWritePre * cal cursor(currPos[1], currPos[2])
]])

vim.cmd([[
	augroup sh_auto_exe
		autocmd BufWritePost *.{sh} !chmod +x <afile>
	augroup end
]])
vim.cmd([[
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
]])

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	-- command = "lua vim.lsp.buf.format()",
-- 	-- pattern = "*.astro,*.cpp,*.cs,*.go,*.h,*.html,*.js,*.json,*.jsx,*.lua,*.md,*.py,*.rs,*.ts,*.tsx,*.yaml",
-- 	pattern = "*",
-- 	callback = function(args)
-- 		require("conform").format({ bufnr = args.buf })
-- 	end,
--})
vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])

-- Resize all windows when we resize the terminal
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("win_autoresize", { clear = true }),
	desc = "autoresize windows on resizing operation",
	command = "wincmd =",
})
-- don't auto comment new line
vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- windows to close with "q"
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"dap-float",
		"fugitive",
		"help",
		"man",
		"notify",
		"null-ls-info",
		"qf",
		"PlenaryTestPopup",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})
vim.api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })
-- Automatically reload the file if it is changed outside of Nvim, see https://unix.stackexchange.com/a/383044/221410.
-- It seems that `checktime` does not work in command line. We need to check if we are in command
-- line before executing this command, see also https://vi.stackexchange.com/a/20397/15292 .
vim.api.nvim_create_augroup("auto_read", { clear = true })

vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
	pattern = "*",
	group = "auto_read",
	callback = function()
		vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.WARN, { title = "nvim-config" })
	end,
})
vim.keymap.set("n", "i", function()
	if #vim.fn.getline(".") == 0 then
		return [["_cc]]
	else
		return "i"
	end
end, { expr = true })

vim.filetype.add({
	extension = {
		astro = "astro",
	},
})

-- Highlight on yank
local yankGrp = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = yankGrp,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight yank",
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions = { c = false, r = false, o = false }
	end,
})
