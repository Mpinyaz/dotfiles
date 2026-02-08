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
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    keys = function()
      return {
        {
          '<leader>E',
          '<Cmd>Neotree toggle<CR>',
          { noremap = true, silent = true },
          desc = 'Toggle Neotree',
        },
      }
    end,
    config = function()
      require('neo-tree').setup {
        open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'edgy' },
        popup_border_style = 'rounded',
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        enable_git_status = true,
        enable_diagnostics = true,

        default_component_configs = {
          container = {
            enable_character_fade = true,
          },
          indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            with_markers = true,
            indent_marker = '▏',
            last_indent_marker = '▏',
            highlight = 'NeoTreeIndentMarker',
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = '',
            expander_expanded = '',
            expander_highlight = 'NeoTreeExpander',
          },
          icon = {
            folder_closed = '󰷏',
            folder_open = '',
            folder_empty = '',
            default = ' ',
            highlight = 'NeoTreeFileIcon',
          },
          modified = {
            symbol = '[+]',
            highlight = 'NeoTreeModified',
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = 'NeoTreeFileName',
          },
          git_status = {
            symbols = {
              -- Change type
              added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = '', -- this can only be used in the git_status source
              renamed = '', -- this can only be used in the git_status source
              -- Status type
              untracked = '',
              ignored = '',
              -- unstaged = "",
              unstaged = 'U',
              staged = '',
              conflict = '',
            },
          },
          diagnostics = {
            symbols = {
              hint = '裂',
              info = '',
              warn = '',
              error = '',
            },
            highlights = {
              hint = 'DiagnosticSignHint',
              info = 'DiagnosticSignInfo',
              warn = 'DiagnosticSignWarn',
              error = 'DiagnosticSignError',
            },
          },
        },
        window = {
          position = 'left',
          width = 50,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ['<leader>e'] = {
              'toggle_node',
              nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ['<1-LeftMouse>'] = 'open',
            ['<cr>'] = 'open',
            ['o'] = 'open',
            ['S'] = 'open_split',
            ['h'] = function(state)
              local node = state.tree:get_node()
              if node.type == 'directory' and node:is_expanded() then
                require('neo-tree.sources.filesystem').toggle_directory(state, node)
              else
                require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
              end
            end,
            ['l'] = function(state)
              local node = state.tree:get_node()
              if node.type == 'directory' then
                if not node:is_expanded() then
                  require('neo-tree.sources.filesystem').toggle_directory(state, node)
                elseif node:has_children() then
                  require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
                end
              end
            end,
            ['s'] = 'open_vsplit',
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ['t'] = 'open_tabnew',
            ['w'] = 'open_with_window_picker',
            ['C'] = 'close_node',
            ['a'] = {
              'add',
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = 'relative', -- "none", "relative", "absolute"
              },
            },
            ['A'] = 'add_directory', -- also accepts the config.show_path option.
            ['d'] = 'delete',
            ['r'] = 'rename',
            ['y'] = 'copy_to_clipboard',
            ['x'] = 'cut_to_clipboard',
            ['p'] = 'paste_from_clipboard',
            ['P'] = 'toggle_preview',
            ['c'] = 'copy', -- takes text input for destination
            ['m'] = 'move', -- takes text input for destination
            ['q'] = 'close_window',
            ['R'] = 'refresh',
            ['?'] = 'show_help',
          },
        },
        filesystem = {
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              --"node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta"
            },
            never_show = { -- remains hidden even if visible is toggled to true
              '.DS_Store',
              'thumbs.db',
            },
          },
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every
            leave_dirs_open = true,
          },
          group_empty_dirs = false, -- when true, empty folders will be grouped together
          hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
          use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
          window = {
            mappings = {
              ['H'] = 'navigate_up',
              ['<bs>'] = 'toggle_hidden',
              ['.'] = 'set_root',
              ['/'] = 'fuzzy_finder',
              ['f'] = 'filter_on_submit',
              ['<c-x>'] = 'clear_filter',
              ['[g'] = 'prev_git_modified',
              [']g'] = 'next_git_modified',
            },
          },
        },
        file_size = {
          enabled = true,
          required_width = 10,
        },
        buffers = {
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every
          },
          -- time the current file is changed while the tree is open.
          group_empty_dirs = true, -- when true, empty folders will be grouped together
          show_unloaded = true,
          window = {
            mappings = {
              ['bd'] = 'buffer_delete',
              ['<bs>'] = 'navigate_up',
              ['.'] = 'set_root',
            },
          },
        },
        git_status = {
          window = {
            position = 'float',
            mappings = {
              ['A'] = 'git_add_all',
              ['gu'] = 'git_unstage_file',
              ['ga'] = 'git_add_file',
              ['gr'] = 'git_revert_file',
              ['gc'] = 'git_commit',
              ['gp'] = 'git_push',
              ['gg'] = 'git_commit_and_push',
            },
          },
        },
        renderers = {
          directory = {
            { 'indent' },
            { 'icon' },
            { 'current_filter' },
            {
              'container',
              content = {
                { 'name', zindex = 10 },
                -- {
                --   "symlink_target",
                --   zindex = 10,
                --   highlight = "NeoTreeSymbolicLinkTarget",
                -- },
                { 'clipboard', zindex = 10 },
                {
                  'diagnostics',
                  errors_only = true,
                  zindex = 20,
                  align = 'right',
                  hide_when_expanded = false,
                },
                {
                  'git_status',
                  zindex = 10,
                  align = 'right',
                  hide_when_expanded = true,
                },
              },
            },
          },
          file = {
            { 'indent' },
            { 'icon' },
            {
              'container',
              content = {
                {
                  'name',
                  zindex = 10,
                },
                {
                  'symlink_target',
                  zindex = 10,
                  highlight = 'NeoTreeSymbolicLinkTarget',
                },
                { 'clipboard', zindex = 10 },
                { 'bufnr', zindex = 10 },
                { 'modified', zindex = 20, align = 'right' },
                { 'diagnostics', zindex = 20, align = 'right' },
                { 'git_status', zindex = 15, align = 'right' },
              },
            },
          },
          message = {
            { 'indent', with_markers = false },
            { 'name', highlight = 'NeoTreeMessage' },
          },
          terminal = {
            { 'indent' },
            { 'icon' },
            { 'name' },
            { 'bufnr' },
          },
        },
      }
    end,
  },
}
