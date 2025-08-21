return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    modes = {
      char = {
        jump_labels = true,
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump({
  search = { forward = true, wrap = false, multi_window = false },
}) end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").jump({
  search = { forward = false, wrap = false, multi_window = false },
}) end, desc = "Flash Treesitter" },
  },
}
