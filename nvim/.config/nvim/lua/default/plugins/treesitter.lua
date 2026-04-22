return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    opts = {
      indent = { enable = true },
      highlight = { enable = true },
      folds = { enable = true },
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
      },
    },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function(_, opts)
      local ts = require 'nvim-treesitter'

      for _, parser in ipairs(opts.ensure_installed) do
        pcall(ts.install, parser)
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)

          if not lang then return end

          -- load parser and start treesitter safely
          pcall(vim.treesitter.language.add, lang)
          pcall(vim.treesitter.start, buf, lang)

          -- -- enable indentation (skip yaml/markdown)
          -- if ft ~= 'yaml' and ft ~= 'markdown' then
          --   vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          --   vim.bo[buf].smartindent = false
          --   vim.bo[buf].cindent = false
          -- end
        end,
      })
      require('ts_context_commentstring').setup {}
      local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)
    end,
  },
}
