return {
  {
    'williamboman/mason.nvim',
    build = ':MasonInstallAll',
    config = function()
      require('mason').setup {
        ui = {
          border = 'shadow',
          zindex = 99,
        },
      }
    end,
  },
  'williamboman/mason-lspconfig.nvim',
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
    config = function()
      require('typescript-tools').setup {
        settings = {
          tsserver_file_preferences = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
            quotePreference = 'auto',
          },
          tsserver_format_options = {
            allowIncompleteCompletions = false,
            allowRenameOfImportPath = false,
          },
        },
      }
    end,
  },
  {
    'zapling/mason-conform.nvim',
    event = 'BufReadPre',
    config = true,
    dependencies = {
      'williamboman/mason.nvim',
      'stevearc/conform.nvim',
    },
  },
  {
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  -- 'jubnzv/virtual-types.nvim',
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {
        text = {
          spinner = 'dots',
          done = '✓',
          commenced = 'Started',
          completed = 'Completed',
        },
        align = {
          bottom = true,
          right = true,
        },
        timer = {
          spinner_rate = 125,
          fidget_decay = 2000,
          task_decay = 1000,
        },
        window = {
          relative = 'win',
          blend = 0,
          zindex = nil,
          border = 'rounded',
        },
      }
      -- ------------------------------------------------------------------------------
      local lspsaga = require 'lspsaga'
      lspsaga.setup {
        -- defaults ...
        debug = false,
        use_saga_diagnostic_sign = false,
        -- diagnostic sign
        error_sign = '',
        warn_sign = '',
        hint_sign = '',
        infor_sign = '',
        diagnostic_header_icon = '   ',
        -- code action title icon
        code_action_icon = ' ',
        code_action_prompt = {
          enable = true,
          sign = true,
          sign_priority = 40,
          virtual_text = false,
        },
        finder_definition_icon = '  ',
        finder_reference_icon = '  ',
        max_preview_lines = 10,
        finder_action_keys = {
          open = 'o',
          vsplit = 's',
          split = 'i',
          quit = 'q',
          scroll_down = '<C-f>',
          scroll_up = '<C-b>',
        },
        code_action_keys = {
          quit = 'q',
          exec = '<CR>',
        },
        rename_action_keys = {
          quit = '<C-c>',
          exec = '<CR>',
        },
        definition_preview_icon = '',
        border_style = 'single',
        rename_prompt_prefix = '➤',
        rename_output_qflist = {
          enable = false,
          auto_open_qflist = false,
        },
        server_filetype_map = {},
        diagnostic_prefix_format = '%d. ',
        diagnostic_message_format = '%m %c',
        highlight_prefix = false,
      }
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons', -- optional
    },
  },
  {
    'MysticalDevil/inlay-hints.nvim',
    event = 'LspAttach',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('inlay-hints').setup {
        commands = { enable = true },
        autocmd = { enable = true },
      }
    end,
  },

  'b0o/schemastore.nvim',
  'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    ft = { 'rust' },
    opts = {
      server = {
        on_attach = on_attach,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
            check = {
              command = 'clippy',
            },
            checkOnSave = {
              allFeatures = true,
              command = 'clippy',
              -- extraArgs = { "--all", "--", "-W", "clippy::all" },
            },
            assist = {
              importEnforceGranularity = true,
              importPrefix = 'crate',
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            inlayHints = {
              locationLinks = true,
              lifetimeElisionHints = {
                enable = true,
                useParameterNames = true,
              },
              chainingHints = {
                enable = true,
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
            procMacro = {
              enable = true,
              ignored = {
                leptos_macro = {
                  -- optional: --
                  -- "component",
                  'server',
                },
              },
            },
          },
        },
      },
    },
  },
  {
    'rust-lang/rust.vim',
    ft = 'rust',
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
    },
    config = function()
      require 'config.lspconfig'
    end,
    opts = {
      library = { plugins = { 'neotest', 'nvim-dap-ui' }, types = true },
      inlay_hints = { enabled = true },
    },
  },
}
