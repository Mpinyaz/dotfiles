return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
  "b0o/schemastore.nvim",
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    dependencies = {
      -- {'gonstoll/wezterm-types', lazy = true},
      { "Bilal2453/luvit-meta", lazy = true },
    },
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { "nvim-dap-ui" },
        -- {path = 'wezterm-types', mods = {'wezterm'}},
      },
    },
  },
  {
    "tzachar/highlight-undo.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require("highlight-undo").setup({})
    end,
  },
  {
    "piersolenski/wtf.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
        --stylua: ignore
        keys = {
            { "<leader>sD", function() require("wtf").ai() end,     desc = "Search Diagnostic with AI" },
            { "<leader>sd", function() require("wtf").search() end, desc = "Search Diagnostic with Google" },
        },
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
  },
  { "echasnovski/mini.animate", version = "*" },
  {
    "yamatsum/nvim-cursorline",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      require("nvim-cursorline").setup({})
    end,
  },
  "chrisbra/csv.vim",
  { "jbyuki/one-small-step-for-vimkind", module = "osv" },
  "nvim-lua/popup.nvim",
  { "j-hui/fidget.nvim", tag = "legacy" },
  "lunarvim/darkplus.nvim",
  { "nanotee/zoxide.vim" },
  {
    "axkirillov/hbac.nvim",
    event = "VeryLazy",
    opts = {
      autoclose = true,
      threshold = 10,
    },
  },
  { "svrana/neosolarized.nvim" },
  {
    "mvllow/modes.nvim",
    tag = "v0.2.0",
    config = function()
      require("modes").setup({
        colors = {
          insert = "#00ff00",
          normal = "#0000ff",
          replace = "#ff0000",
          visual = "#ff00ff",
        },
      })
    end,
  },
  { "HiPhish/rainbow-delimiters.nvim" },
}
