local servers = require("utils.servers")
local icons = require("utils.icons")
-- ----------------------------------------------------------------------
-- --                        LSP Client attach                         --
-- ----------------------------------------------------------------------
local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
  textDocument = {
    foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
    completion = {
      completionItem = {
        -- documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            "documentation",
            "additionalTextEdits",
            "insertTextFormat",
            "insertTextMode",
            "command",
          },
        },
      },
      contextSupport = true,
    },
  },
})
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
local function on_init(client, result)
  client.server_capabilities =
    vim.tbl_deep_extend("force", client.server_capabilities, capabilities)

  -- Set empty trigger characters for signatureHelp if supported
  if client:supports_method("textDocument/signatureHelp") then
    client.server_capabilities.signatureHelpProvider.triggerCharacters = {}
  end

  -- Handle off-spec "offsetEncoding" server capability
  if result.offsetEncoding then
    client.offset_encoding = result.offsetEncoding
  end
end

-- Create an augroup for LSP-related autocommands
vim.api.nvim_create_augroup("lsp", { clear = true })
local telescope_ok, telescope = pcall(require, "telescope.builtin")

-- Wrapper for keymapping with default opts
local map = function(mode, lhs, rhs, desc)
  local opts = {
    noremap = true,
    silent = true,
    desc = "LSP: " .. desc,
  }
  vim.keymap.set(mode, lhs, rhs, opts)
end

vim.api.nvim_create_augroup("lsp", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = "lsp",
  callback = function(args)
    local bufnr = args.buf
    local client_id = args.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)

    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local opts = { noremap = true, silent = true }
    -- Store LSP client name in buffer-local variable
    vim.b[bufnr].lsp = client.name
    require("lsp_signature").on_attach({
      bind = true,
      floating_window = true,
      always_trigger = true,
      hint_enable = true,
      hint_prefix = "🔍 ",
    }, bufnr)
    -- Mappings
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Go to next diagnostic")
    map("n", "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "Go to the previous diagnostic")
    map("n", "ge", "<Cmd>Lspsaga show_line_diagnostic<CR>", "Show diagnostics of the current line")
    map("n", "gd", "<Cmd>Lspsaga peek_definition<CR>", "Show diagnostics of the current line")
    map("n", "gr", "<Cmd>Lspsaga rename ++projects<CR>", "Rename variable under cursor")
    map("n", "<leader>ca", "<Cmd>Lspsaga code_action<CR>", "Code actions")
    map("n", "gf", "<Cmd>Lspsaga finder<CR>", "Find references and implementation under cursor")
    map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Show hover doc")
    map("n", "go", "<cmd>Lspsaga outline<CR>", "Show Lsp outline")
    map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Show hover doc")

    if telescope_ok then
      map("n", "<leader>d", telescope.diagnostics, "Show all diagnostics")
    else
      map(
        "n",
        "<leader>d",
        "<Cmd>Lspsaga show_workspace_diagnostics ++float<CR>",
        "Show all diagnostics"
      )
    end
    if client.server_capabilities.documentFormattingProvider then
      buf_set_keymap("n", "<leader>Cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
    end

    if client.server_capabilities.documentRangeFormattingProvider then
      buf_set_keymap("v", "<leader>cf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
      vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
        desc = "Highlight references under the cursor",
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
        desc = "Clear highlight references",
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- Document highlight
    if client:supports_method("textDocument/documentHighlight", bufnr) then
      vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
        group = "lsp",
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
        group = "lsp",
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- Inlay hints toggle
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Code lens
    if client:supports_method("textDocument/codeLens", bufnr) then
      vim.api.nvim_create_autocmd("LspProgress", {
        group = "lsp",
        pattern = "end",
        callback = function(progress_args)
          if progress_args.buf == bufnr then
            vim.lsp.codelens.refresh({ bufnr = bufnr })
          end
        end,
      })

      vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
        group = "lsp",
        buffer = bufnr,
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = bufnr })
        end,
      })

      vim.lsp.codelens.refresh({ bufnr = bufnr })
    end

    -- Folding
    -- if client.supports_method("textDocument/foldingRange") then
    -- 	vim.wo.foldmethod = "expr"
    -- vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
    -- end

    -- Formatting
    if client:supports_method("textDocument/formatting", bufnr) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = "lsp",
        buffer = bufnr,
        callback = function()
          local autoformat = vim.F.if_nil(
            client.settings.autoformat,
            vim.b[bufnr].lsp and vim.b[bufnr].lsp.autoformat,
            vim.g.lsp and vim.g.lsp.autoformat,
            false
          )

          if autoformat then
            vim.lsp.buf.format({ bufnr = bufnr, id = client_id })
          end
        end,
      })
    end
  end,
})

----------------------------------------------------------------------
--                         Lsp Diagnostics                          --
----------------------------------------------------------------------
--

local config = {
  virtual_text = false, -- appears after the line
  virtual_lines = true, -- appears under the line
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
    },
  },
  flags = {
    debounce_text_changes = 200,
    allow_incremental_sync = true,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focus = false,
    focusable = true,
    style = "minimal",
    border = "shadow",
    source = "always",
  },
}
vim.diagnostic.config(config)

vim.lsp.config("*", {
  capabilities = capabilities,
  on_init = on_init,
})

vim.lsp.enable(servers)
return {
  {
    "mason-org/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      local mason_ok, mason = pcall(require, "mason")
      if not mason_ok then
        return
      end
      mason.setup({
        ensure_installed = servers,
        automatic_installation = true,
        ui = {
          border = "shadow",
          icons = require("utils.icons").mason,
          check_outdated_packages_on_open = true,
        },
      })
      -- require("mason-lspconfig").setup({
      --   ensure_installed = servers,
      -- })
    end,
  },
  {
    "zapling/mason-conform.nvim",
    event = "BufReadPre",
    config = true,
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim",
    },
  },
  {
    "MaximilianLloyd/tw-values.nvim",
    keys = {
      { "<Leader>cv", "<CMD>TWValues<CR>", desc = "Tailwind CSS values" },
    },
    opts = {
      show_unknown_classes = true, --
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    opts = {},
  },
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        text = {
          spinner = "dots",
          done = "✓",
          commenced = "Started",
          completed = "Completed",
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
          relative = "win",
          blend = 0,
          zindex = nil,
          border = "rounded",
        },
      })
      local lspsaga = require("lspsaga")
      lspsaga.setup({
        -- defaults ...
        debug = true,
        diagnostic = {
          keys = {
            quit = { "q", "<ESC>" },
          },
        },
        use_saga_diagnostic_sign = false,
        -- diagnostic sign
        error_sign = "",
        warn_sign = "",
        hint_sign = "",
        infor_sign = "",
        diagnostic_header_icon = "   ",
        -- code action title icon
        code_action_icon = " ",
        code_action_prompt = {
          enable = true,
          sign = true,
          sign_priority = 40,
          virtual_text = false,
        },
        finder_definition_icon = "  ",
        finder_reference_icon = "  ",
        max_preview_lines = 10,
        finder_action_keys = {
          open = "o",
          vsplit = "s",
          split = "i",
          quit = "q",
          scroll_down = "<C-f>",
          scroll_up = "<C-b>",
        },
        code_action_keys = {
          quit = "q",
          exec = "<CR>",
        },
        rename_action_keys = {
          quit = "<C-c>",
          exec = "<CR>",
        },
        definition_preview_icon = "",
        border_style = "single",
        rename_prompt_prefix = "➤",
        rename_output_qflist = {
          enable = false,
          auto_open_qflist = false,
        },
        server_filetype_map = {},
        diagnostic_prefix_format = "%d. ",
        diagnostic_message_format = "%m %c",
        highlight_prefix = false,
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      jsx_close_tag = {
        enable = true,
        filetypes = { "javascriptreact", "typescriptreact" },
      },
    },
  },
  {
    "ray-x/go.nvim",
    -- ... dependencies and other keys ...
    config = function()
      require("go").setup({
        -- Disable built-in linting to let nvim-lint handle it
        luasnip = true,
        lsp_codelens = true,
        lint_on_save = false, -- THIS IS THE KEY FIX
        lsp_keymaps = false,
        lsp_diag_update_in_insert = false,
        lsp_inlay_hints = {
          enable = true,
        },
        golangci_lint = {
          default = "all", -- set to one of { 'standard', 'fast', 'all', 'none' }
          disable = { "errcheck", "staticcheck" }, -- linters to disable empty by default
          enable = { "govet", "ineffassign", "revive", "gosimple" }, -- linters to enable; empty by default
          config = nil, -- set to a config file path
          no_config = false, -- true: golangci-lint --no-config
          severity = vim.diagnostic.severity.INFO, -- severity level of the diagnostics
        },
        -- Ensure gopls is configured for your environment
        lsp_cfg = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
              },
            },
          },
        },
      })
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    dependencies = "neovim/nvim-lspconfig",
    version = "^6", -- Recommended
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
              ignored = {
                leptos_macro = {
                  -- optional: --
                  -- "component",
                  "server",
                },
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            check = {
              command = "clippy",
            },
            checkOnSave = {
              command = "clippy",
              extraArgs = { "--all", "--", "-W", "clippy::all" },
            },
            assist = {
              importEnforceGranularity = true,
              importPrefix = "crate",
            },
            inlayHints = {
              locationLinks = true,
              lifetimeElisionHints = {
                enable = true,
                useParameterNames = true,
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    config = function()
      require("ts-error-translator").setup({
        auto_attach = true,

        servers = {
          "astro",
          "svelte",
          "ts_ls",
          -- "tsserver", -- deprecated, use ts_ls
          "typescript-tools",
          "volar",
          "vtsls",
        },
      })
    end,
  },
}
