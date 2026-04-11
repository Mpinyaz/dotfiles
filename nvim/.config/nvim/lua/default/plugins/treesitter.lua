return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' }, -- Must use main branch here too
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      -- 2. Configure Textobjects (The "New Way" - standalone setup)
      require('nvim-treesitter-textobjects').setup {
        select = {
          move = {
            set_jumps = true,
          },
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            -- ['@class.outer'] = '<c-v>', -- blockwise
          },
          include_surrounding_whitespace = false,
        },
      }

      -- 3. Configure Other Plugins
      require('ts_context_commentstring').setup {}

      local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ 'x', 'o' }, 'am', function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'im', function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end)
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ 'x', 'o' }, 'as', function() require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals') end)
    end,
  },
}
