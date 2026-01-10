return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      -- import nvim-treesitter plugin
      local treesitter = require("nvim-treesitter.configs")

      -- configure treesitter
      treesitter.setup({
        ensure_installed = {
          "typescript",
          "vim",
          "vimdoc",
          "html",
          "rust",
          "markdown",
          "markdown_inline",
          "latex",
          "bibtex",
        }, -- one of "all", "maiantained" (parsers with maintainers), or a list of languages
        auto_install = true,
        sync_install = true, -- enable syntax highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
        },
        -- enable indentation
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<Leader>vs",
            node_incremental = "<Leader>vi",
            node_decremental = "<Leader>vd",
            scope_incremental = "<Leader>vc",
          },
        },
        textobjects = {
          enable = true,
          disable = {},
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["aC"] = "@class.outer",
              ["iC"] = "@class.inner",
              ["ac"] = "@conditional.outer",
              ["ic"] = "@conditional.inner",
              ["ie"] = "@block.inner",
              ["al"] = "@loop.outer",
              ["ae"] = "@block.outer",
              ["il"] = "@loop.inner",
              ["is"] = "@statement.inner",
              ["as"] = "@statement.outer",
              ["am"] = "@call.outer",
              ["ad"] = "@comment.outer",
              ["im"] = "@call.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          lsp_interop = {
            enable = true,
            border = "rounded",
            peek_definition_code = {
              ["<leader>dg"] = "@function.outer",
              ["<leader>dG"] = "@class.outer",
            },
          },
        },
        textsubjects = {
          enable = true,
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = "textsubjects-container-inner",
          },
        },
        refactor = {
          highlight_definitions = {
            enable = true,
          },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = "gnr",
            },
          },
          navigation = {
            enable = true,
            keymaps = {
              goto_definition = "gnd",
              list_definitions = "gnD",
            },
          },
        },
      })
      require("ts_context_commentstring").setup({})
      require("nvim-treesitter-textsubjects").configure({
        prev_selection = ",",
      })
      -- Fix: Use expr=true for builtin_f_expr mappings
      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

      -- Make builtin f, F, t, T repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

      -- Make ; and , repeat the last f/F/t/T motion
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

      -- Optional: Make textobject movements repeatable
      vim.keymap.set({ "n", "x", "o" }, "]m", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, "[m", ts_repeat_move.repeat_last_move_previous)
    end,
  },
}
