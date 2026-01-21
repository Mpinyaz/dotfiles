return {
  {
    "MeanderingProgrammer/markdown.nvim",
    ---@module "render-markdown",
    ---@type render.md.UserConfig
    opts = {
      render_modes = { "n", "c", "t" },
      file_types = { "markdown", "vimwiki", "quarto" },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- Mandatory
      "nvim-tree/nvim-web-devicons", -- Optional but recommended
      "Mofiqul/dracula.nvim",
    },
    config = function()
      local colors = require("dracula").colors()
      local hl = vim.api.nvim_set_hl

      -- Headings
      hl(0, "RenderMarkdownH1", { fg = colors.pink, bold = true })
      hl(0, "RenderMarkdownH2", { fg = colors.purple, bold = true })
      hl(0, "RenderMarkdownH3", { fg = colors.cyan, bold = true })
      hl(0, "RenderMarkdownH4", { fg = colors.green, bold = true })
      hl(0, "RenderMarkdownH5", { fg = colors.orange, bold = true })
      hl(0, "RenderMarkdownH6", { fg = colors.yellow, bold = true })

      -- Heading backgrounds (blend with bg)
      hl(0, "RenderMarkdownH1Bg", { bg = colors.visual })
      hl(0, "RenderMarkdownH2Bg", { bg = colors.visual })
      hl(0, "RenderMarkdownH3Bg", { bg = colors.visual })
      hl(0, "RenderMarkdownH4Bg", { bg = colors.visual })
      hl(0, "RenderMarkdownH5Bg", { bg = colors.visual })
      hl(0, "RenderMarkdownH6Bg", { bg = colors.visual })

      -- Code
      hl(0, "RenderMarkdownCode", { bg = colors.selection })
      hl(0, "RenderMarkdownCodeInline", { bg = colors.selection, fg = colors.green })

      -- Quotes
      hl(0, "RenderMarkdownQuote", { fg = colors.comment, italic = true })

      -- Lists
      hl(0, "RenderMarkdownBullet", { fg = colors.cyan })
      hl(0, "RenderMarkdownDash", { fg = colors.comment })

      -- Links
      hl(0, "RenderMarkdownLink", { fg = colors.cyan, underline = true })
      hl(0, "RenderMarkdownWikiLink", { fg = colors.purple, underline = true })

      -- Checkboxes
      hl(0, "RenderMarkdownUnchecked", { fg = colors.comment })
      hl(0, "RenderMarkdownChecked", { fg = colors.green })
      hl(0, "RenderMarkdownTodo", { fg = colors.orange })

      -- Tables
      hl(0, "RenderMarkdownTableHead", { fg = colors.purple, bold = true })
      hl(0, "RenderMarkdownTableRow", { fg = colors.fg })

      -- Callouts
      hl(0, "RenderMarkdownSuccess", { fg = colors.green })
      hl(0, "RenderMarkdownInfo", { fg = colors.cyan })
      hl(0, "RenderMarkdownHint", { fg = colors.purple })
      hl(0, "RenderMarkdownWarn", { fg = colors.orange })
      hl(0, "RenderMarkdownError", { fg = colors.red })
      require("obsidian").get_client().opts.ui.enable = false
      require("render-markdown").setup({
        completions = { blink = { enabled = true } },
      })
    end,
  },
  {
    "brianhuster/live-preview.nvim",
    keys = { { "<leader>mp", "<cmd>LivePreview start<cr>", "Toggle Preview file" } },
    dependencies = {
      "ibhagwan/fzf-lua",
    },
  },
  {
    "gaoDean/autolist.nvim",
    ft = {
      "markdown",
      "text",
      "tex",
      "plaintex",
      "norg",
    },
    config = function()
      require("autolist").setup()

      vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
      vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
      -- vim.keymap.set("i", "<c-t>", "<c-t><cmd>AutolistRecalculate<cr>") -- an example of using <c-t> to indent
      vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
      vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
      vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
      vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
      vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

      -- cycle list types with dot-repeat
      vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })
      vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, { expr = true })

      -- if you don't want dot-repeat
      -- vim.keymap.set("n", "<leader>cn", "<cmd>AutolistCycleNext<cr>")
      -- vim.keymap.set("n", "<leader>cp", "<cmd>AutolistCycleNext<cr>")

      -- functions to recalculate list on edit
      vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
      vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
      vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
      vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
    end,
  },
}
