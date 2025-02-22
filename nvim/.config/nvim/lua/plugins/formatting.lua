return {
  'stevearc/conform.nvim',
  cmd = { 'ConformInfo', 'FormatToggle', 'FormatEnable', 'FormatDisable' },
  event = { 'BufReadPre', 'BufNewFile' }, -- to disable, comment this out
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  config = function()
    local conform = require 'conform'
    local web_formatter = { 'prettierd', 'biome-check', stop_after_first = true }

    conform.setup {
      format = {
        timeout_ms = 3000,
        async = true,
        quiet = false,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        javascript = web_formatter,
        typescript = web_formatter,
        javascriptreact = web_formatter,
        typescriptreact = web_formatter,
        svelte = web_formatter,
        css = web_formatter,
        html = web_formatter,
        json = web_formatter,
        yaml = { 'prettierd' },
        markdown = { 'prettierd' },
        graphql = { 'prettierd' },
        lua = { 'stylua' },
        rust = { 'rustfmt', lsp_fallback = true },
        python = { 'isort', 'black' },
        fish = { 'fish_indent' },
        c = { 'clang_format' },
        sh = { 'shfmt' },
        toml = { 'taplo' },
        sql = { 'sqlfmt' },
      },
      format_on_save = { timeout_ms = 500, async = false, lsp_format = 'fallback' },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>qf', function()
      conform.format {
        lsp_fallback = true,
        async = true,
        timeout_ms = 1000,
      }
    end, { desc = 'Format file or range (in visual mode)' })
  end,
}
