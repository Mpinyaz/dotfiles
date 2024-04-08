_G.dump = function(...)
	print(vim.inspect(...))
end

_G.prequire = function(...)
	local status, lib = pcall(require, ...)
	if status then
		return lib
	end
	return nil
end

local M = {}

function M.t(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.log(msg, hl, name)
	name = name or "Neovim"
	hl = hl or "Todo"
	vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function M.open_term(cmd, opts)
	opts = opts or {}
	opts.size = opts.size or vim.o.columns * 0.5
	opts.direction = opts.direction or "float"
	opts.on_open = opts.on_open or default_on_open
	opts.on_exit = opts.on_exit or nil
	opts.dir = opts.dir or "git_dir"

	local Terminal = require("toggleterm.terminal").Terminal
	local new_term = Terminal:new({
		cmd = cmd,
		dir = opts.dir,
		auto_scroll = false,
		close_on_exit = false,
		start_in_insert = false,
		on_open = opts.on_open,
		on_exit = opts.on_exit,
	})
	new_term:open(opts.size, opts.direction)
end

function M.warn(msg, name)
	vim.notify(msg, vim.log.levels.WARN, { title = name })
end

function M.is_empty(s)
	return s == nil or s == ""
end

function M.error(msg, name)
	vim.notify(msg, vim.log.levels.ERROR, { title = name })
end

function M.info(msg, name)
	vim.notify(msg, vim.log.levels.INFO, { title = name })
end

function M.get_buf_option(opt)
	local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
	if not status_ok then
		return nil
	else
		return buf_option
	end
end

local function bind(op, outer_opts)
	outer_opts = outer_opts or { noremap = true }
	return function(lhs, rhs, opts)
		opts = vim.tbl_extend("force", outer_opts, opts or {})
		vim.keymap.set(op, lhs, rhs, opts)
	end
end

M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")
M.tnoremap = bind("t")

function M.quit()
	local bufnr = vim.api.nvim_get_current_buf()
	local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
	if modified then
		vim.ui.input({
			prompt = "You have unsaved changes. Quit anyway? (y/n) ",
		}, function(input)
			if input == "y" then
				vim.cmd("q!")
			end
		end)
	else
		vim.cmd("q!")
	end
end

---Return OS
---@return string
M.getOS = function()
	local handle = io.popen("uname -s")
	if handle == nil then
		vim.notify("Error while opening handler", vim.log.levels.ERROR)
		return ""
	end
	local uname = handle:read("*a")
	handle:close()
	uname = uname:gsub("%s+", "")
	if uname == "Darwin" then
		return "Darwin"
	elseif uname == "NixOS" then
		return "NixOS"
	elseif uname == "Linux" then
		return "Linux"
	else
		return ""
	end
end

--- Check if the minimum Neovim version is satisfied
--- Expects only the minor version, e.g. "9" for 0.9.1
---@param version number
---@return boolean
M.isNeovimVersionsatisfied = function(version)
	return version <= tonumber(vim.version().minor)
end

---checks if a command is available
---@param command string
---@return boolean
M.isExecutableAvailable = function(command)
	return vim.fn.executable(command) == 1
end

---notify
---@param message string
---@param level integer
---@param title string
M.notify = function(message, level, title)
	local notify_options = {
		title = title,
		timeout = 2000,
	}
	vim.api.nvim_notify(message, level, notify_options)
end

-- Check if a variable is not empty nor nil
M.isNotEmpty = function(s)
	return s ~= nil and s ~= ""
end

--- Check if path exists
M.path_exists = function(path)
	return vim.loop.fs_stat(path)
end

-- Return telescope files command
M.project_files = function()
	local path = vim.loop.cwd() .. "/.git"
	if M.path_exists(path) then
		return "Telescope git_files"
	else
		return "Telescope find_files"
	end
end

-- toggle quickfixlist
M.toggle_qf = function()
	local windows = fn.getwininfo()
	local qf_exists = false
	for _, win in pairs(windows) do
		if win["quickfix"] == 1 then
			qf_exists = true
		end
	end
	if qf_exists == true then
		cmd("cclose")
		return
	end
	if M.isNotEmpty(fn.getqflist()) then
		cmd("copen")
	end
end

-- toggle colorcolumn
M.toggle_colorcolumn = function()
	local value = vim.api.nvim_get_option_value("colorcolumn", {})
	if value == "" then
		M.notify("Enable colocolumn", 1, "functions.lua")
		vim.api.nvim_set_option_value("colorcolumn", "79", {})
	else
		M.notify("Disable colocolumn", 1, "functions.lua")
		vim.api.nvim_set_option_value("colorcolumn", "", {})
	end
end

-- move over a closing element in insert mode
M.escapePair = function()
	local closers = { ")", "]", "}", ">", "'", '"', "`", "," }
	local line = vim.api.nvim_get_current_line()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local after = line:sub(col + 1, -1)
	local closer_col = #after + 1
	local closer_i = nil
	for i, closer in ipairs(closers) do
		local cur_index, _ = after:find(closer)
		if cur_index and (cur_index < closer_col) then
			closer_col = cur_index
			closer_i = i
		end
	end
	if closer_i then
		vim.api.nvim_win_set_cursor(0, { row, col + closer_col })
	else
		vim.api.nvim_win_set_cursor(0, { row, col + 1 })
	end
end

-- @author kikito
-- @see https://codereview.stackexchange.com/questions/268130/get-list-of-buffers-from-current-neovim-instance
-- currently not used
function M.get_listed_buffers()
	local buffers = {}
	local len = 0
	for buffer = 1, vim.fn.bufnr("$") do
		if vim.fn.buflisted(buffer) == 1 then
			len = len + 1
			buffers[len] = buffer
		end
	end

	return buffers
end

function M.map(mode, l, r, opts)
	opts = opts or {}
	vim.keymap.set(mode, l, r, opts)
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

---load user config file .nvim_config.lua
---@return table
function M.load_user_config()
	local home = os.getenv("XDG_CONFIG_HOME")
		or os.getenv("HOME")
		or os.getenv("USERPROFILE")
		or (os.getenv("HOMEDRIVE") .. os.getenv("HOMEPATH"))
	local config_file = home .. M.path_separator() .. ".nvim_config.lua"
	local ok, err = pcall(dofile, config_file)
	if not ok then
		M.notify("Can not load user config: " .. err, vim.log.levels.INFO, "utils")
		return {}
	else
		return dofile(config_file)
	end
end

---returns OS dependent path separator
---@return string
M.path_separator = function()
	local is_windows = vim.fn.has("win32") == 1
	if is_windows == true then
		return "\\"
	else
		return "/"
	end
end

---Merge two tables into the first table
---@param t1 table
---@param t2 table
---@return table
M.merge_tables = function(t1, t2)
	for k, v in pairs(t2) do
		if (type(v) == "table") and (type(t1[k] or false) == "table") then
			M.merge_tables(t1[k], t2[k])
		else
			t1[k] = v
		end
	end
	return t1
end

---returns the number of items in a table
---@param t table
---@return integer
M.table_length = function(t)
	local count = 0
	for _ in pairs(t) do
		count = count + 1
	end
	return count
end

function M.list_registered_providers_names(filetype)
	local s = require("null-ls.sources")
	local available_sources = s.get_available(filetype)
	local registered = {}
	for _, source in ipairs(available_sources) do
		for method in pairs(source.methods) do
			registered[method] = registered[method] or {}
			table.insert(registered[method], source.name)
		end
	end
	return registered
end

---Search for TODO|HACK|FIXME|NOTE with rg and
---populate quickfixlist with the results
M.search_todos = function()
	local result
	result = vim.fn.system("rg --json --case-sensitive -w 'TODO|HACK|FIXME|NOTE'")
	if result == nil then
		return
	end
	local lines = vim.split(result, "\n")
	local qf_list = {}

	for _, line in ipairs(lines) do
		if line ~= "" then
			local data = vim.fn.json_decode(line)
			if data ~= nil then
				if data.type == "match" then
					local submatches = data.data.submatches[1]
					table.insert(qf_list, {
						filename = data.data.path.text,
						lnum = data.data.line_number,
						col = submatches.start,
						text = data.data.lines.text,
					})
				end
			end
		end
	end

	if next(qf_list) ~= nil then
		vim.fn.setqflist(qf_list)
		vim.cmd("copen")
	else
		local utils = require("utils.functions")
		utils.notify("No results found!", vim.log.levels.INFO, "Search TODOs")
	end
end
return M
