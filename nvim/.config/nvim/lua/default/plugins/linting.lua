return {
  {
    "rshkarin/mason-nvim-lint",
    opts = {
      automatic_installation = true,
      ignore_install = { "biome" },
    },
    dependencies = { "mfussenegger/nvim-lint", "williamboman/mason.nvim" },
  },
  {
    "mfussenegger/nvim-lint",
    lazy = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", os.getenv("HOME") .. ".markdownlint.yaml", "--" },
        },
      },
    },
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        markdown = { "markdownlint" },
        typescript = { "eslint_d" },
        javascript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        python = { "pylint" },
        lua = { "luacheck" },
        zsh = { "shellcheck" },
        sh = { "shellcheck" },
        stylelint = { "stylelint" },
        go = { "golangcilint" },
      }
      local eslint = lint.linters.eslint_d

      eslint.args = {
        "--no-warn-ignored", -- <-- this is the key argument
        "--format",
        "json",
        "--stdin",
        "--stdin-filename",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      }
      lint.linters.eslint_d = require("lint.util").wrap(lint.linters.eslint_d, function(diagnostic)
        -- try to ignore "No ESLint configuration found" error
        -- if diagnostic.message:find("Error: No ESLint configuration found") then -- old version
        -- update: 20240814, following is working
        if diagnostic.message:find("Error: Could not find config file") then
          return nil
        end
        return diagnostic
      end)
      lint.linters.luacheck = {
        cmd = "luacheck",
        stdin = true,
        args = {
          "--globals",
          "vim",
          "lvim",
          "reload",
          "--",
        },
        stream = "stdout",
        ignore_exitcode = true,
        parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
          source = "luacheck",
        }),
      }
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>ql", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },
}
