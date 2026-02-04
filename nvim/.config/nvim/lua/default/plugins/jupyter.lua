return {
  {
    'benlubas/molten-nvim',
    build = ':UpdateRemotePlugins',
    keys = {
      { '<localleader>ji', ':MoltenInit<CR>' },
      { '<localleader>jr', ':MoltenReevaluateCell<CR>' },
      { '<localleader>jv', ':<C-u>MoltenEvaluateVisual<CR>gv', mode = 'v' },
      { '<localleader>jh', ':MoltenHideOutput<CR>' },
      { '<localleader>js', ':MoltenShowOutput<CR>' },
      -- { '<localleader>hl', ':MoltenEvaluateLine<CR>' },
      { '<localleader>jd', ':MoltenDelete<CR>' },
      { '<localleader>jx', ':MoltenOpenInBrowser<CR>' },
    },
    dependencies = {
      -- depends on jupytext converting .ipynb files on open.
      'goerz/jupytext.vim',
      'benlubas/quarto-nvim',
      {
        '3rd/image.nvim',
        -- additional opts that are required within molten
        opts = {
          max_width = 100,
          max_height = 12,
          max_height_window_percentage = math.huge,
          max_width_window_percentage = math.huge,
          window_overlap_clear_enabled = true,
          window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
        },
      },
    },
    init = function()
      vim.g.molten_auto_open_output = true
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_crop_border = true

      vim.g.molten_output_win_max_height = 40
      vim.g.molten_virt_text_output = true
      vim.g.molten_use_border_highlights = true
      -- vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_wrap_output = true

      vim.keymap.set('n', '<leader>mi', ':MoltenInit<CR>', { desc = 'Initialize Molten', silent = true })
      vim.keymap.set('n', '<leader>ir', function()
        local venv = os.getenv 'VIRTUAL_ENV'
        if venv ~= nil then
          venv = string.match(venv, '/.+/(.+)')
          vim.cmd(('MoltenInit %s'):format(venv))
        else
          vim.cmd 'MoltenInit python3'
        end
      end, { desc = 'Initialize Molten for python3', silent = true, noremap = true })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MoltenInitPost',
        callback = function()
          -- change some vim settings
          vim.opt.conceallevel = 0
          vim.cmd [[ TSContextDisable ]]

          -- ... always just activate quarto?
          require('quarto').activate()
          vim.notify 'Quarto activated.' -- maybe put this in a pcall w/ .activate() to actually check if we're good

          local r = require 'quarto.runner'
          vim.keymap.set('n', '<leader>rc', r.run_cell, { desc = 'run cell', silent = true })
          vim.keymap.set('n', '<leader>rA', r.run_all, { desc = 'run all cells', silent = true })

          vim.keymap.set('n', '<Esc>', ':noautocmd MoltenHideOutput<CR>', { desc = 'Close output window', silent = true })

          vim.keymap.set('n', ']x', ':noautocmd MoltenNext<CR>', { desc = 'Next Molten Cell', silent = true })
          vim.keymap.set('n', '[x', ':noautocmd MoltenPrev<CR>', { desc = 'Previous Molten Cell', silent = true })
        end,
      })
    end,
  },
  {
    'benlubas/quarto-nvim',
    dependencies = {
      -- LSP for code embedded in other file formats (e.g. python in markdown)
      -- (should this have its own config???)
      'jmbuhr/otter.nvim',

      -- make sure LSP niceties are loaded (is this a dep cycle?)
      'hrsh7th/nvim-cmp',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
      'benlubas/molten-nvim',
    },
    keys = {
      { '<localleader>hc', ':lua require("quarto.runner").run_cell()<CR>' },
      { '<localleader>ha', ':lua require("quarto.runner").run_above()<CR>' },
      { '<localleader>hb', ':lua require("quarto.runner").run_below()<CR>' },
      { '<localleader>hA', ':lua require("quarto.runner").run_all()<CR>' },
      { '<localleader>hl', ':lua require("quarto.runner").run_line()<CR>' },
      { '<localleader>hr', ':lua require("quarto.runner").run_range()<CR>', mode = 'v' },
    },
    ft = { 'quarto', 'markdown' },
    config = function()
      local quarto = require 'quarto'
      quarto.setup {
        lspFeatures = {
          languages = { 'python', 'rust' },
          chunks = 'all',
          diagnostics = {
            enabled = true,
            triggers = { 'BufWritePost' },
          },
          completion = {
            enabled = true,
          },
        },
        keymap = {
          hover = 'K',
          definition = 'gd',
          rename = '<space>r',
          references = 'gr',
          format = '<space>f',
        },
        codeRunner = {
          enabled = true,
          default_method = 'molten',
        },
      }
    end,
  },
  {
    -- see the image.nvim readme for more information about configuring this plugin
    '3rd/image.nvim',
    opts = {
      backend = 'kitty', -- whatever backend you would like to use
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
  },
  { -- directly open ipynb files as quarto docuements
    -- and convert back behind the scenes
    'GCBallesteros/jupytext.nvim',
    opts = {
      custom_language_formatting = {
        python = {
          extension = 'md',
          style = 'markdown',
          force_ft = 'markdown', -- you can set whatever filetype you want here
        },
      },
    },
  },
}
