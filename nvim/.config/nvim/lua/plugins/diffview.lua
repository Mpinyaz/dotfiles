return {
  "sindrets/diffview.nvim",
  cmd = "DiffviewOpen",
  config = true,
  keys = {
    { "<leader>do", "<cmd>DiffviewOpen<cr>" },
    { "<leader>dq", "<cmd>DiffviewClose<cr>" },
    { "<leader>dm", "<cmd>DiffviewPrompt<cr>" },
  },
}
