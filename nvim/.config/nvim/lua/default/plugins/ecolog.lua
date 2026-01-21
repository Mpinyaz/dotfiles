return {
  "philosofonusus/ecolog.nvim",
  keys = {
    { "<leader>ge", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
    { "<leader>gpe", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
    { "<leader>gps", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
    { "<leader>gpc", "<cmd>EcologCopy<cr>", desc = "Copy var to clipboard" },
    { "<leader>gpl", "<cmd>EcologShelterLinePeek<cr>", desc = "Ecolog Line Peek" },
    { "<leader>gpo", "<cmd>EcologShelterToggle<cr>", desc = "Ecolog Toggle" },
    { "<leader>gpk", "<cmd>EcologSagaHover<cr>", desc = "Ecolog Hover" },
    { "<leader>gpf", "<cmd>EcologSnacks<cr>", desc = "Env Picker" },
  },
  opts = {

    types = true,
    path = vim.fn.getcwd(),
    load_shell = {
      enabled = true, -- Enable shell variable loading
      override = false, -- When false, .env files take precedence over shell variables
      -- Optional: filter specific shell variables
      filter = function(key, _value)
        -- Example: only load specific variables
        return key:match("^(PATH|HOME|USER)$") ~= nil
      end,
      -- Optional: transform shell variables before loading
      transform = function(_key, value)
        -- Example: prefix shell variables for clarity
        return "[shell] " .. value
      end,
    },
  },
  config = function()
    require("ecolog").setup({
      integrations = {
        statusline = {
          hidden_mode = false, -- Hide when no env file is loaded
          icons = {
            enabled = true, -- Enable icons in statusline
            env = "🌲", -- Icon for environment file
            shelter = "🛡️", -- Icon for shelter mode
          },
        },
        omnifunc = true,
        blink_cmp = true,
        snacks = true,
        fzf = true,
        lspsaga = true,
      },
    })
    require("telescope").load_extension("ecolog")
    vim.o.statusline = "%{%v:lua.require'ecolog'.get_status()%}"
  end,
}
