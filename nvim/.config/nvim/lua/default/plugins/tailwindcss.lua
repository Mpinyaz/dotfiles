return {
  {
    'roobert/tailwindcss-colorizer-cmp.nvim',
    dependencies = { 'hrsh7th/nvim-cmp' },
    -- optionally, override the default options:
    config = function()
      require('tailwindcss-colorizer-cmp').setup {
        color_square_width = 2,
      }
      require('cmp').config.formatting = {
        format = require('tailwindcss-colorizer-cmp').formatter,
      }
    end,
  },
  {
    'NvChad/nvim-colorizer.lua',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
    config = function()
      local nvchadcolorizer = require 'colorizer'
      local tailwindcolorizer = require 'tailwindcss-colorizer-cmp'

      nvchadcolorizer.setup {
        user_default_options = {
          tailwind = true,
        },
        filetypes = { 'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'svelte', 'astro' },
      }

      tailwindcolorizer.setup {
        color_square_width = 2,
      }
    end,
  },
}
