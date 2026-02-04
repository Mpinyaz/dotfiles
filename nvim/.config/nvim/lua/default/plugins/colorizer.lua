return {
  {
    'brenoprata10/nvim-highlight-colors',
    event = 'VeryLazy',
    opts = {
      render = 'foreground',
      enabled_tailwind = true,
      virtual_symbol = '',
    },
    config = function() require('nvim-highlight-colors').setup {} end,
  },
  {
    'uga-rosa/ccc.nvim',
    event = 'FileType',
    keys = {
      { '<Leader>mc', '<cmd>CccPick<CR>', desc = 'Color-picker' },
    },
    opts = {
      highlighter = {
        auto_enable = false,
        lsp = true,
        filetypes = {
          'html',
          'lua',
          'css',
          'scss',
          'sass',
          'less',
          'stylus',
          'javascript',
          'tmux',
          'typescript',
        },
        excludes = { 'lazy', 'mason', 'help', 'neo-tree' },
      },
    },
  },
}
