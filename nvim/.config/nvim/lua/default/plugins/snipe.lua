return {
  'leath-dub/snipe.nvim',
  keys = {
    {
      '<leader>bl',
      function() require('snipe').open_buffer_menu() end,
      desc = 'Open Snipe buffer menu',
    },
  },
  config = function()
    local snipe = require 'snipe'
    snipe.setup {
      hints = {
        dictionary = 'asfghl;wertyuiop',
      },
      navigate = {
        cancel_snipe = '<esc>',
        -- NOTE: Make sure you don't use the character below on your dictionary
        close_buffer = 'd',
      },
      sort = 'default',
    }
  end,
}
