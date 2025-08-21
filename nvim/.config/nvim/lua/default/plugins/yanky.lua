return {
  "gbprod/yanky.nvim",
  event = "BufReadPre",
  opts = {
    ring = {
      history_length = 1000,
      storage = "shada",
      sync_with_numbered_registers = true,
    },
    system_clipboard = {
      sync_with_ring = true,
    },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 1500,
    },
    preserve_cursor_position = {
      enabled = true,
    },
  },
  keys = {
    { "gp", "`[v`]", desc = "Select last paste" },
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
    { "<c-p>", "<Plug>(YankyCycleForward)" },
    { "<c-n>", "<Plug>(YankyCycleBackward)" },
    { "<leader>pp", "<cmd>YankyRingHistory<cr>" },
  },
}
