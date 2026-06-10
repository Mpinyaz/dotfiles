return {
  {
    'MeanderingProgrammer/markdown.nvim',
    ---@module "render-markdown",
    ---@type render.md.UserConfig
    opts = {
      render_modes = { 'n', 'c', 't' },
      restart_highlighter = true,
      file_types = { 'markdown', 'vimwiki', 'quarto', 'rmd' },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- Mandatory
      'nvim-tree/nvim-web-devicons', -- Optional but recommended
      'Mofiqul/dracula.nvim',
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function() vim.treesitter.start() end,
      })
    end,
    config = function()
      require('obsidian').get_client().opts.ui.enable = false
      require('render-markdown').setup {
        completions = { blink = { enabled = true } },
      }
    end,
  },
  {
    'brianhuster/live-preview.nvim',
    keys = { { '<leader>mp', '<cmd>LivePreview start<cr>', 'Toggle Preview file' } },
    dependencies = {
      'ibhagwan/fzf-lua',
    },
  },
  {
    'gaoDean/autolist.nvim',
    ft = {
      'markdown',
      'text',
      'tex',
      'plaintex',
      'norg',
    },
    config = function()
      require('autolist').setup()

      -- vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
      -- vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
      -- -- vim.keymap.set("i", "<c-t>", "<c-t><cmd>AutolistRecalculate<cr>") -- an example of using <c-t> to indent
      -- vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
      -- vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
      -- vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
      -- vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
      -- vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")
      --
      -- -- cycle list types with dot-repeat
      -- vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })
      -- vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true })
      --
      -- -- if you don't want dot-repeat
      -- -- vim.keymap.set("n", "<leader>cn", "<cmd>AutolistCycleNext<cr>")
      -- -- vim.keymap.set("n", "<leader>cp", "<cmd>AutolistCycleNext<cr>")
      --
      -- -- functions to recalculate list on edit
      -- vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
      -- vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
      -- vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
      -- vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
    end,
  },
}
