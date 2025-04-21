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
    },
    config = function()
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
}
