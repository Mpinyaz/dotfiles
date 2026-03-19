return {
  'kylechui/nvim-surround',
  version = '*', -- Use for stability; omit to use `main` branch for the latest features
  event = 'VeryLazy',
  config = function()
    require('nvim-surround').setup {
      aliases = {
        ['a'] = 'a',
        ['b'] = 'b',
        ['B'] = 'B',
        ['r'] = 'r',
        ['q'] = { '"', "'", '`' }, -- Any quote character
        [';'] = { ')', ']', '}', '>', "'", '"', '`' }, -- Any surrounding delimiter
      },
    }
  end,
}
