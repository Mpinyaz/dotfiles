return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      endwise = { enable = true },
      ensure_installed = {
        'bash',
        'bicep',
        'cmake',
        'css',
        'dockerfile',
        'go',
        'hcl',
        'html',
        'java',
        'javascript',
        'json',
        'kotlin',
        'ledger',
        'lua',
        'markdown',
        'markdown_inline',
        'query',
        'python',
        'regex',
        'terraform',
        'templ',
        'toml',
        'vim',
        'yaml',
        'c',
        'cpp',
      },
    },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'RRethy/nvim-treesitter-endwise', -- mainly for Lua 'closing end' insertion
      { 'nvim-mini/mini.ai', event = { 'BufReadPre', 'BufNewFile' }, opts = {} },
    },
    config = function(_, opts)
      local ts = require 'nvim-treesitter'

      for _, parser in ipairs(opts.ensure_installed) do
        pcall(ts.install, parser)
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = opts.ensure_installed,
        callback = function() vim.treesitter.start() end,
      })
      require('ts_context_commentstring').setup {}
      local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    lazy = true,
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
            ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
            ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
            ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },
            ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
            ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },
            ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
            ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },
            ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
            ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },
            ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
            ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },
            ['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
            ['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },
            ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
            ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>na'] = '@parameter.inner',
            ['<leader>nm'] = '@function.outer',
          },
          swap_previous = {
            ['<leader>pa'] = '@parameter.inner',
            ['<leader>pm'] = '@function.outer',
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']f'] = { query = '@call.outer', desc = 'Next function call start' },
            [']m'] = { query = '@function.outer', desc = 'Next method/function def start' },
            [']c'] = { query = '@class.outer', desc = 'Next class start' },
          },
          goto_previous_start = {
            ['[f'] = { query = '@call.outer', desc = 'Prev function call start' },
            ['[m'] = { query = '@function.outer', desc = 'Prev method/function def start' },
            ['[c'] = { query = '@class.outer', desc = 'Prev class start' },
          },
        },
      }

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ 'x', 'o' }, 'am', function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'im', function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end)
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ 'x', 'o' }, 'as', function() require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals') end)
      -- Repeatable move logic remains the same
      local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr)
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr)
    end,
  },
  {
    'fei6409/log-highlight.nvim',
    opts = {},
  },
}
