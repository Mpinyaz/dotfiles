return {
  'jiaoshijie/undotree',
  dependencies = 'nvim-lua/plenary.nvim',
  config = true,
  opts = {
    ignore_filetype = {
      'Undotree',
      'UndotreeDiff',
      'qf',
      'TelescopePrompt',
      'spectre_panel',
      'tsplayground',
    },
    window = {
      winblend = 2,
    },
    keymaps = {
      ['j'] = 'move_next',
      ['k'] = 'move_prev',
      ['J'] = 'move_change_next',
      ['K'] = 'move_change_prev',
      ['<cr>'] = 'action_enter',
      ['p'] = 'enter_diffbuf',
      ['q'] = 'quit',
    },
  },
  keys = { -- load the plugin only when using it's keybinding:
    { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>" },
  },
}
