---@type LazySpec
return {
  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    dependencies = {
      -- check the installation instructions at
      -- https://github.com/folke/snacks.nvim
      'folke/snacks.nvim',
    },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        '<leader>e',
        mode = { 'n', 'v' },
        '<cmd>Yazi<cr>',
        desc = 'Open yazi at the current file',
      },
      {
        -- Open in the current working directory
        '<leader>cw',
        '<cmd>Yazi cwd<cr>',
        desc = "Open the file manager in nvim's working directory",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      floating_window_scaling_factor = 0.8,
      keymaps = {
        show_help = '<f1>',
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  {
    'echasnovski/mini.files',
    dependencies = { 'folke/which-key.nvim' },
    version = '*',
    keys = {
      {
        '<leader>E',
        function()
          local MiniFiles = require 'mini.files'
          if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end
        end,
        desc = 'Files',
      },
    },
    init = function()
      local wk = require 'which-key'
      wk.add {
        { '<leader>E', desc = 'Files', icon = ' ', mode = 'n' },
      }

      local function open_files(data)
        local directory = vim.fn.isdirectory(data.file) == 1

        if not directory then return end

        -- change to the directory
        vim.cmd.cd(data.file)

        -- open the tree
        require('mini.files').open(vim.api.nvim_buf_get_name(0), false)
      end
      vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_files })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesWindowUpdate',
        callback = function(args)
          -- vim.wo[args.data.win_id].number = true
          vim.wo[args.data.win_id].relativenumber = true
        end,
      })
    end,
    config = function()
      require('mini.files').setup {
        windows = {
          preview = false,
          max_number = math.huge,
          width_focus = 30,
          width_nofocus = 20,
          width_preview = 25,
        },
        mappings = {
          synchronize = '<leader>bw',
        },
        use_as_default_explorer = true,
      }
    end,
  },
}
