local profile_path = vim.fn.stdpath("config") .. "/profiles/default"

dofile(profile_path .. "/config/options.lua")
dofile(profile_path .. "/config/keymaps.lua")
dofile(profile_path .. "/config/autocmds.lua")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    -- bootstrap lazy.nvim
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath })
end

vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
require("lazy").setup({
  { import = "shared" },
  { import = "default.plugins" },
}, {
  ui = {
    border = "shadow",
  },
  dev = {
    path = "~/.ghq/github.com",
  },
  -- checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    cache = {
      enabled = true,
      -- disable_events = {},
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  install = {
    colorscheme = { "nightfox" },
    missing = true,
  },
})
