return {
  "craftzdog/solarized-osaka.nvim",
  -- {
  --   "rebelot/kanagawa.nvim",
  --   opts = {
  --     theme = "lotus",
  --   },
  --   config = function()
  --     vim.cmd("colorscheme kanagawa-wave")
  --   end,
  -- },
  {
    "AetherSyscall/AetherAmethyst.nvim",
    priority = 1000,
    config = function()
      require("aetheramethyst").setup({
        transparent = false, -- Enable transparent background
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = { bold = true },
          variables = {},
        },
      })

      -- Load the variant: 'eclipse' (dark) or 'bliss' (light)
      vim.cmd("colorscheme aetheramethyst-eclipse")
    end,
  },
  -- {
  --   "scottmckendry/cyberdream.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = true,
  --     italic_comments = false,
  --     cache = true,
  --     extensions = {
  --       telescope = true,
  --       notify = true,
  --       mini = true,
  --     },
  --   },
  --   config = function()
  --     vim.cmd("colorscheme cyberdream")
  --   end,
  -- },
  { "edeneast/nightfox.nvim" },
  -- {
  -- 	"rose-pine/neovim",
  -- 	name = "rose-pine",
  -- 	config = function()
  -- 		vim.g.rose_pine_variant = "auto"
  -- 		vim.g.rose_pine_disable_background = true
  -- 		vim.cmd("colorscheme rose-pine")
  -- 	end,
  -- },
  -- {
  --         'eldritch-theme/eldritch.nvim',
  --         lazy = false,
  --         priority = 1000,
  --         opts = {
  --                 transparent = true,
  --                 dim_inactive = true,
  --         },
  --         config = function()
  --                 vim.cmd [[colorscheme eldritch]]
  --         end,
  -- },
  -- {
  -- 	"folke/tokyonight.nvim",
  -- 	config = function()
  -- 		vim.g.tokyonight_style = "night"
  -- 		vim.g.tokyonight_italic_functions = true
  -- 		vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
  -- 		vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" }
  -- 		vim.cmd("colorscheme tokyonight-night")
  -- 	end,
  -- },
  -- {
  -- "catppuccin/nvim",
  -- name = "catppuccin",
  -- priority = 1000,
  -- config = function()
  -- 	require("catppuccin").setup({
  -- 		flavour = "mocha", -- latte, frappe, macchiato, mocha
  -- 		background = { -- :h background
  -- 			light = "latte",
  -- 			dark = "mocha",
  -- 		},
  -- 		transparent_background = true,
  -- 		integrations = {
  -- 			cmp = true,
  -- 			gitsigns = true,
  -- 			nvimtree = true,
  -- 			treesitter = true,
  -- 			leap = true,
  -- 			notify = true,
  -- 			mini = false,
  -- 		},
  -- 	})
  --
  -- 	vim.cmd.colorscheme("catppuccin")
  -- end,
  -- },
  -- {
  --   "tiagovla/tokyodark.nvim",
  --   opts = {
  --     -- custom options here
  --   },
  --   config = function(_, opts)
  --     require("tokyodark").setup(opts) -- calling setup is optional
  --     vim.cmd([[colorscheme tokyodark]])
  --   end,
  -- },
  -- {
  -- 	"EdenEast/nightfox.nvim",
  -- 	config = function()
  -- 		vim.cmd([[colorscheme nightfox]])
  -- 	end,
  -- },
}
