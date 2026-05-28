return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = 'markdown',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>ob', '<cmd>ObsidianBacklinks<CR>', desc = 'Obsidian backlinks' },
      { '<leader>od', '<cmd>ObsidianToday<CR>', desc = 'Obsidian daily note' },
      { '<leader>ol', '<cmd>ObsidianLinks<CR>', desc = 'Obsidian note links' },
      { '<leader>oo', '<cmd>ObsidianOpen<CR>', desc = 'Open in Obsidian' },
      { '<leader>oq', '<cmd>ObsidianQuickSwitch<CR>', desc = 'Obsidian quick switch' },
      { '<leader>os', '<cmd>ObsidianSearch<CR>', desc = 'Search Obsidian notes' },
      { '<leader>ot', '<cmd>ObsidianTemplate<CR>', desc = 'Insert Obsidian template' },
      { '<leader>oT', '<cmd>ObsidianTOC<CR>', desc = 'Obsidian table of contents' },
    },
    config = function()
      local function dir_exists(path)
        local stat = vim.loop.fs_stat(path)
        return stat and stat.type == 'directory'
      end

      -- Define potential workspaces
      local potential_workspaces = {
        {
          name = 'Notes',
          path = '/Users/eltonmpinyuri/Documents/Obsidian Vault/',
        },
        {
          name = 'Work',
          path = '/Users/eltonmpinyuri/Documents/Work Vault/',
        },
        {
          name = 'Personal',
          path = '/home/mpinyaz/Documents/Obsidian Vault/',
        },
      }

      -- Only add workspaces that exist
      local workspaces = {}
      for _, workspace in ipairs(potential_workspaces) do
        local expanded_path = vim.fn.expand(workspace.path)
        if dir_exists(expanded_path) then table.insert(workspaces, {
          name = workspace.name,
          path = expanded_path,
        }) end
      end

      require('obsidian').setup {
        workspaces = workspaces,
        legacy_commands = false,
        -- Add other obsidian settings here
      }
    end,
  },

  {
    'snapwich/obsidian-tasks.nvim',
    branch = 'main', -- Forces Lazy to track the latest branch updates
    dependencies = {
      'epwalsh/obsidian.nvim', -- Fixed the typo in the dependency name here too
      'saghen/blink.cmp',
    },
    config = function() require('obsidian-tasks').setup {} end,
  },
}
