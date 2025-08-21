local profile = os.getenv("NVIM_PROFILE") or "default"

local profile_path = vim.fn.stdpath("config") .. "/profiles/" .. profile .. "/init.lua"
if vim.fn.filereadable(profile_path) == 1 then
  dofile(profile_path)
else
  -- Load default configuration
  vim.notify("Profile '" .. profile .. "' not found, falling back to default", vim.log.levels.ERROR)
  require("config.default")
end
