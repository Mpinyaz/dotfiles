return {
  "rmagatti/goto-preview",
  keys = {

    {
      "<leader>pd",
      function()
        require("goto-preview").goto_preview_definition()
      end,
      { desc = "Preview Definition", silent = true },
    },
    {
      "<leader>pt",
      function()
        require("goto-preview").goto_preview_type_definition()
      end,
      { desc = "Preview Type Definition", silent = true },
    },
    {
      "<leader>pi",
      function()
        require("goto-preview").goto_preview_type_definition()
      end,
      { desc = "Preview Implementation", silent = true },
    },
    {
      "<leader>pr",
      function()
        require("goto-preview").goto_preview_references()
      end,
      { desc = "Preview References", silent = true },
    },
    {
      "<leader>pq",
      function()
        require("goto-preview").close_all_win()
      end,
      { desc = "Close Previews", silent = true },
    },
  },
  config = function()
    require("goto-preview").setup({
      border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
      default_mappings = true,
      debug = false, -- Print debug information
      opacity = 30, -- 0-100 opacity level of the floating window where 100 is fully transparent.
      resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
      post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
      references = { -- Configure the telescope UI for slowing the references cycling window.
        telescope = require("telescope.themes").get_dropdown({ hide_preview = false }),
      },
      -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
      focus_on_open = true, -- Focus the floating window when opening it.
      dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
      force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
      bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
      stack_floating_preview_windows = true, -- Whether to nest floating windows
      preview_window_title = { enable = true, position = "left" }, -- Whether
    })
  end,
}
