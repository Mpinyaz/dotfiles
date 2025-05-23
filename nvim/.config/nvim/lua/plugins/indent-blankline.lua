return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
      chunk = {
        use_treesitter = true,
        notify = true,
        enable = true,
        style = {
          "#8B00FF",
          "#0000FF",
        },
        delay = 0,
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
        },
      },
      indent = {
        enable = true,
        exclude_filetypes = {
          fidget = true,
          dashboard = true,
          lspinfo = true,
          mason = true,
          help = true,
        },
        -- style = {
        --   "#FF0000",
        --   "#FF7F00",
        --   "#FFFF00",
        --   "#00FF00",
        --   "#00FFFF",
        --   "#0000FF",
        --   "#8B00FF",
        -- },
        -- chars = {
        --   "│",
        --   "¦",
        --   "┆",
        --   "┊",
        -- },
        -- style = {
        --   vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
        -- },
      },
      line_num = {
        enable = true,
        style = "#806d9c",
      },
      blank = {
        enable = true,
        chars = {
          "․",
        },
        style = {
          { vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"), "" },
        },
      },
    })
  end,
}
