return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "ThePrimeagen/harpoon", branch = "harpoon2" },
      "nvim-telescope/telescope-fzy-native.nvim",
      "nvim-telescope/telescope-media-files.nvim",
      { "tiagovla/scope.nvim" },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
      "nvim-tree/nvim-web-devicons",
      "xiyaowong/telescope-emoji",
      "jvgrootveld/telescope-zoxide",
      {
        "benfowler/telescope-luasnip.nvim", -- if you wish to lazy-load
      },
      "nvim-telescope/telescope-symbols.nvim",
      -- "nvim-telescope/telescope-media-files.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "cljoly/telescope-repo.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      { "<leader>gf", require("utils.pickers").git_diff_picker, desc = "Diff Files" },
      {
        "<leader>f",
        function()
          local opts = require("telescope.themes").get_ivy()
          require("telescope.builtin").find_files(opts)
        end,
        desc = "telescope browser",
      },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      -- { "<leader>ss", "<cmd>Telescope luasnip<cr>", desc = "Snippets" },
      { "<leader>r", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>fz", "<cmd>Telescope zoxide list<cr>", desc = "Recent Folders" },
      {
        "<leader>lf",
        function()
          require("telescope.builtin").live_grep({
            search_dirs = { vim.fs.dirname(vim.fn.expand("%")) },
          })
        end,
        desc = "Grep (Current File Path)",
      },
    },
    config = function()
      local status_ok, telescope = pcall(require, "telescope")
      if not status_ok then
        return
      end

      local actions = require("telescope.actions")
      local transform_mod = require("telescope.actions.mt").transform_mod
      local pickers = require("telescope.pickers")
      local Path = require("plenary.path")
      local action_set = require("telescope.actions.set")
      local action_state = require("telescope.actions.state")
      local conf = require("telescope.config").values
      local finders = require("telescope.finders")
      local make_entry = require("telescope.make_entry")
      local os_sep = Path.path.sep
      local scan = require("plenary.scandir")
      local custom_pickers = require("utils.pickers")
      ---Keep track of the active extension and folders for `live_grep`
      local live_grep_filters = {
        ---@type nil|string
        extension = nil,
        ---@type nil|string[]
        directories = nil,
      }
      local function run_live_grep(current_input)
        require("telescope.builtin").live_grep({
          additional_args = live_grep_filters.extension and function()
            return { "-g", "*." .. live_grep_filters.extension }
          end,
          search_dirs = live_grep_filters.directories,
          -- default_text = current_input,
        })
      end
      local cus_actions = transform_mod({

        set_extension = function(prompt_bufnr)
          local current_input = action_state.get_current_line()
          vim.ui.input({ prompt = "*." }, function(input)
            if input == nil then
              return
            end
            live_grep_filters.extension = input
            actions.close(prompt_bufnr)
            run_live_grep(current_input)
          end)
        end,

        set_folders = function(prompt_bufnr)
          local current_input = action_state.get_current_line()
          local data = {}
          scan.scan_dir(vim.loop.cwd(), {
            hidden = true,
            only_dirs = true,
            respect_gitignore = true,
            on_insert = function(entry)
              table.insert(data, entry .. os_sep)
            end,
          })
          table.insert(data, 1, "." .. os_sep)
          actions.close(prompt_bufnr)
          pickers
            .new({}, {
              prompt_title = "Folders for Live Grep",
              finder = finders.new_table({
                results = data,
                entry_maker = make_entry.gen_from_file({}),
              }),
              previewer = conf.file_previewer({}),
              sorter = conf.file_sorter({}),
              attach_mappings = function(bufnr)
                action_set.select:replace(function()
                  local current_picker = action_state.get_current_picker(bufnr)

                  local dirs = {}
                  local selections = current_picker:get_multi_selection()
                  if vim.tbl_isempty(selections) then
                    table.insert(dirs, action_state.get_selected_entry().value)
                  else
                    for _, selection in ipairs(selections) do
                      table.insert(dirs, selection.value)
                    end
                  end
                  live_grep_filters.directories = dirs
                  actions.close(bufnr)
                  run_live_grep(current_input)
                end)
                return true
              end,
            })
            :find()
        end,
      })
      local custom_actions = transform_mod({
        -- Toggleterm
        toggle_term = function(prompt_bufnr)
          -- Get the full path
          local content = require("telescope.actions.state").get_selected_entry()
          if content == nil then
            return
          end

          local file_dir = ""
          if content.filename then
            file_dir = vim.fs.dirname(content.filename)
          elseif content.value then
            if content.cwd then
              file_dir = content.cwd
            end
            file_dir = file_dir .. require("plenary.path").path.sep .. content.value
          end

          -- Close the Telescope window
          require("telescope.actions").close(prompt_bufnr)

          -- Open terminal
          local utils = require("utils.functions")
          utils.open_term(nil, { direction = "float", dir = file_dir })
        end,
      })
      telescope.setup({
        defaults = {
          layout_config = {
            width = 0.75,
            prompt_position = "top",
            preview_cutoff = 120,
            horizontal = { mirror = false },
            vertical = { mirror = false },
          },
          find_command = {
            "rg",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--iglob",
            "!.git",
          },
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "descending",
          layout_strategy = "horizontal",
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          hijack_netrw = true,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-z>"] = custom_actions.toggle_term,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<c-f>"] = cus_actions.set_folders,
              ["<c-l>"] = cus_actions.set_extension,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            },
            n = {
              ["z"] = custom_actions.toggle_term,
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["?"] = actions.which_key,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          },

          fzy_native = {
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = { "png", "webp", "jpg", "jpeg" },
            find_cmd = "rg", -- find command (defaults to `fd`)
          },
          emoji = {
            action = function(emoji)
              -- argument emoji is a table.
              -- {name="", value="", cagegory="", description=""}

              vim.fn.setreg("*", emoji.value)
              print([[Press p or "*p to paste this emoji]] .. emoji.value)

              -- insert emoji when picked
              -- vim.api.nvim_put({ emoji.value }, 'c', false, true)
            end,
          },
        },
      })
      telescope.load_extension("file_browser")
      telescope.load_extension("emoji")
      telescope.load_extension("harpoon")
      telescope.load_extension("noice")
      telescope.load_extension("repo")
      telescope.load_extension("media_files")
      telescope.load_extension("luasnip")
      telescope.load_extension("fzy_native")
      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")
      require("telescope").load_extension("scope")
    end,
  },
}
