local servers = require("utils.servers")
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
  if client.supports_method("textDocument/signatureHelp") then
    client.server_capabilities.signatureHelpProvider.triggerCharacters = {}
  end

  -- Handle off-spec "offsetEncoding" server capability
  if result.offsetEncoding then
    client.offset_encoding = result.offsetEncoding
  end
end

vim.lsp.config["lua-language-server"] = {
  cmd = { "lua-language-server" },
  root_markers = { ".luarc.json", ".git", ".stylua" },
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    Lua = {
      hint = {
        enable = true,
      },
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
        disable = {
          "lowercase-global",
          "undefined-global",
          "unused-local",
          "unused-vararg",
          "trailing-space",
        },
      },
      workspace = {
        -- make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
      -- do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
      completion = {
        callSnippet = "Both",
      },
    },
  },
  filetypes = { "lua" },
}

vim.lsp.config["clangd"] = {
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--header-insertion=iwyu",
  },
  capabilities = capabilities,
  on_init = on_init,
  root_markers = { ".clangd", ".clang-format", "compile_commands.json", "compile_flags.txt" },
  filetypes = { "c", "cpp" },
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
    completeUnimported = true,
    semanticHighlighting = true,
  },
  settings = {
    clangd = {
      InlayHints = {
        Designators = true,
        Enabled = true,
        ParameterNames = true,
        DeducedTypes = true,
      },
      fallbackFlags = { "-std=c++20" },
    },
  },
}

vim.lsp.config["html"] = {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = { "html" },
  capabilities = capabilities,
  on_init = on_init,
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
    provideFormatter = true,
  },
}
vim.lsp.config["bashls"] = {
  cmd = { "bash-language-server", "start" },
  capabilities = capabilities,
  on_init = on_init,
  filetypes = { "sh", "zsh", "bash" },
}
vim.lsp.config["gopls"] = {
  cmd = { "gopls" },
  root_markers = { "go.work", "go.mod", ".git" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    gofumpt = true,
    codelenses = {
      gc_details = false,
      generate = true,
      regenerate_cgo = true,
      run_govulncheck = true,
      test = true,
      tidy = true,
      upgrade_dependency = true,
      vendor = true,
    },
    hints = {
      assignVariableTypes = true,
      compositeLiteralFields = true,
      compositeLiteralTypes = true,
      constantValues = true,
      functionTypeParameters = true,
      parameterNames = true,
      rangeVariableTypes = true,
    },
    analyses = {
      fieldalignment = true,
      nilness = true,
      unusedparams = true,
      unusedwrite = true,
      useany = true,
    },
    usePlaceholders = true,
    completeUnimported = true,
    staticcheck = true,
    directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
    semanticTokens = true,
  },
}
vim.lsp.config["markdown_oxide"] = {
  cmd = { "markdown-oxide" },
  filetypes = { "markdown" },
  capabilities = capabilities,
  on_init = on_init,
}

vim.lsp.config["biome"] = {
  cmd = { "npx", "biome", "lsp-proxy" },
  filetypes = { "js" },
}
vim.lsp.config["yamlls"] = {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      schemas = require("schemastore").yaml.schemas(),
      keyOrdering = false,
      format = { enable = true },
      validate = true,
      schemaStore = {
        --Must disable built-in schemaStore support to use schemas from SchemaStore.nvim plugin
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
    },
  },
}
vim.lsp.config["typescript-language-server"] = {
  cmd = { "typescript-language-server", "--stdio" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  capabilities = capabilities,
  on_init = on_init,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },

  settings = {
    completions = {
      completeFunctionCalls = true,
    },
  },
  javascript = {
    inlayHints = {
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHints = true,
    },
  },
  typescript = {
    inlayHints = {
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHints = true,
    },
  },
}
vim.lsp.config["rust_analyzer"] = {
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
  filetypes = { "rust" },
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    ["rust-analyzer"] = {
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
      cargo = {
        allFeatures = true,
      },
      inlayHints = {
        locationLinks = true,
        lifetimeElisionHints = {
          enable = true,
          useParameterNames = true,
        },
      },
      procMacro = {
        ignored = {
          leptos_macro = {
            -- optional: --
            -- "component",
            "server",
          },
        },
      },
    },
  },
}

vim.lsp.config["jsonls"] = {
  cmd = { "vscode-json-language-server", "--stdio" },
  capabilities = capabilities,
  on_init = on_init,
  filetypes = { "json" },
  settings = {
    json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } },
  },
}

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
    -- Mappings
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    map("n", "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", "Go to next diagnostic")
    map("n", "ge", "<Cmd>Lspsaga show_line_diagnostic<CR>", "Show diagnostics of the current line")
    map("n", "gd", "<Cmd>Lspsaga peek_definition<CR>", "Show diagnostics of the current line")
    map("n", "gr", "<Cmd>Lspsaga rename ++projects<CR>", "Rename variable under cursor")
    map("n", "<leader>ca", "<Cmd>Lspsaga code_action<CR>", "Code actions")
    map("n", "gf", "<Cmd>Lspsaga finder<CR>", "Find references and implementation under cursor")
    map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Show hover doc")
    map("n", "go", "<cmd>Lspsaga outline<CR>", "Show Lsp outline")
    map("n", "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "Go to the previous diagnostic")
    map("n", "K", "<cmd>Lspsaga hover_doc<CR>", "Show hover doc")
    if telescope_ok then
      map("n", "<leader>d", telescope.diagnostics, "Show all diagnostics")
    else
      map("n", "<leader>E", function()
        vim.diagnostic.setloclist()
      end, "Show all diagnostics")
    end

    if client.server_capabilities.documentFormattingProvider then
      buf_set_keymap("n", "<leader>Cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
    end
    -- if client.server_capabilities.inlayHintProvider then
    -- 	require("inlay-hints").on_attach(client, bufnr)
    -- end
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
    if client.supports_method("textDocument/documentHighlight") then
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
    if client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
        { bufnr = bufnr }
      )
    end

    -- Code lens
    if client.supports_method("textDocument/codeLens") then
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
    if client.supports_method("textDocument/formatting") then
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

    -- Completion
    -- if client.supports_method("textDocument/completion") then
    -- 	if client.name == "lua-language-server" then
    -- 		client.server_capabilities.completionProvider.triggerCharacters = { ".", ":" }
    -- 	end
    -- 	vim.lsp.completion.enable(true, client_id, bufnr, { autotrigger = true })
    -- end
  end,
})

----------------------------------------------------------------------
--                         Lsp Diagnostics                          --
----------------------------------------------------------------------
--
local icons = require("utils.icons")

local config = {
  -- virtual_text = true, -- appears after the line
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
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, "/") .. ":" .. vim.env.PATH
vim.diagnostic.config(config)

vim.lsp.enable(servers)

return {
  {
    "williamboman/mason.nvim",

    config = function()
      local servers = require("utils.servers")
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
  -- {
  --   "nvimtools/none-ls.nvim",
  --   config = function()
  --     local null_ls = require("null-ls")
  --
  --     null_ls.setup({
  --       sources = {
  --         null_ls.builtins.code_actions.gitsigns,
  --         null_ls.builtins.code_actions.refactoring,
  --       },
  --     })
  --   end,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     {
  --       "ThePrimeagen/refactoring.nvim",
  --       dependencies = {
  --         "nvim-lua/plenary.nvim",
  --         "nvim-treesitter/nvim-treesitter",
  --       },
  --       lazy = false,
  --       opts = {},
  --     },
  --   },
  -- },
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
        debug = false,
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
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
