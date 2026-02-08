return {

  'ibhagwan/fzf-lua',
  event = 'VeryLazy',
  requires = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    files = {
      cwd_prompt = false,
      cmd = 'fd --type f --hidden --exclude .git --follow',
    },
    fzf_colors = {
      true,
      bg = '-1',
      gutter = '-1',
    },
  },
  keys = {
    {
      '<leader>nc',
      function() require('fzf-lua').commands() end,
      desc = 'Search commands',
    },
    {
      '<leader>nC',
      function() require('fzf-lua').command_history() end,
      desc = 'Search command history',
    },
    {
      '<leader>nf',
      function() require('fzf-lua').files() end,
      desc = 'Find files',
    },
    {
      '<leader>nt',
      function() require('fzf-lua').live_grep { cmd = 'git grep --line-number --column --color=always' } end,
      desc = 'Find in files',
    },
    {
      '<leader>nb',
      function() require('fzf-lua').grep() end,
      desc = 'Find with regex',
    },
    {
      '<leader>no',
      function() require('fzf-lua').oldfiles() end,
      desc = 'Find fi',
    },
    {
      '<leader>nM',
      function() require('fzf-lua').marks() end,
      desc = 'Search marks',
    },
    {
      '<leader>nk',
      function() require('fzf-lua').keymaps() end,
      desc = 'Search keymaps',
    },
    {
      '<leader>ns',
      function() require('fzf-lua').spell_suggest() end,
      desc = 'Spell suggestions',
    },
    {
      '<leader>ngf',
      function() require('fzf-lua').git_files() end,
      desc = 'Find git files',
    },
    {
      '<leader>ngb',
      function() require('fzf-lua').git_branches() end,
      desc = 'Search git branches',
    },
    {
      '<leader>ngc',
      function() require('fzf-lua').git_commits() end,
      desc = 'Search git commits',
    },
    {
      '<leader>ngC',
      function() require('fzf-lua').git_bcommits() end,
      desc = 'Search git buffer commits',
    },
    {
      '<leader>nr',
      function() require('fzf-lua').resume() end,
      desc = 'Resume FZF',
    },
    {
      '<leader>nlr',
      function() require('fzf-lua').lsp_references() end,
      desc = 'References',
    },
    {
      'gf',
      function() require('fzf-lua').lsp_finder() end,
      desc = 'Lsp Finder',
    },
    {
      '<leader>gd',
      function() require('fzf-lua').lsp_definitions() end,
      desc = 'Definitions',
    },
    {
      '<leader>gi',
      function() require('fzf-lua').lsp_implementations() end,
      desc = 'Implementations',
    },
    {
      '<leader>d',
      function() require('fzf-lua').lsp_workspace_diagnostics() end,
      desc = 'Code Actions',
    },
  },
  config = function()
    local fzf = require 'fzf-lua'
    fzf.setup {
      keymap = {
        fzf = {
          ['CTRL-Q'] = 'select-all+accept',
        },
      },
    }
    fzf.register_ui_select()
  end,
}
