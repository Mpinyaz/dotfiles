local profile_path = vim.fn.stdpath("config") .. "/profiles/default"
-- Load specific files
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
