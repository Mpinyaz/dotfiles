return {
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
    lazy = false,
    init = function()
      local wk = require 'which-key'
      wk.add {
        {
          '<leader>cl',
          function() require('Comment.api').toggle.linewise.current() end,
          desc = 'Toggle comment',
          mode = 'n',
        },
        {
          '<leader>cl',
          "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
          desc = 'Toggle comment',
          mode = 'v',
        },
      }
    end,
    config = function(_, opts) require('Comment').setup(opts) end,
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function() require('ts_context_commentstring').setup {} end,
  },
  {
    's1n7ax/nvim-comment-frame',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter' },
    },
    config = function()
      require('nvim-comment-frame').setup()
      vim.api.nvim_set_keymap('n', '<leader>cc', ":lua require('nvim-comment-frame').add_comment()<CR>", {})
    end,
  },
}
