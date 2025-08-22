-- Clean Go debugging setup using nvim-dap-go properly

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mxsdev/nvim-dap-vscode-js",
      "leoluz/nvim-dap-go",
      "mason-org/mason.nvim",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
          "mfussenegger/nvim-dap",
          "williamboman/mason.nvim",
        },
        opts = {
          ensure_installed = {
            "codelldb",
            "delve",
          },
        },
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI first
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      })

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = true,
        clear_on_continue = false,
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
      })

      -- Setup dap-go BEFORE defining any custom configurations
      -- This is crucial - let dap-go set up the adapter first
      require("dap-go").setup({
        -- Let dap-go handle the default configurations
        dap_configurations = {
          {
            -- Additional custom configuration
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        -- Delve configuration
        delve = {
          -- Path to the executable dlv which will be used for debugging
          path = "dlv",
          -- Time to wait for delve to initialize the debug session
          initialize_timeout_sec = 20,
          -- Port to start delve debugger
          port = "${port}",
          -- Additional args to pass to dlv
          args = {},
          -- Build flags that are passed to delve
          build_flags = "",
          -- Whether the dlv process should be created detached or not
          detached = vim.fn.has("win32") == 0,
          -- Current working directory to run dlv
          cwd = nil,
        },
        tests = {
          -- Enable verbosity when running tests
          verbose = false,
        },
      })

      -- Add additional custom configurations AFTER dap-go setup
      -- This ensures we don't override the adapter configuration
      local go_configs = dap.configurations.go or {}

      -- Add our custom configurations to the existing ones
      local custom_configs = {
        {
          type = "go",
          name = "Debug with Arguments",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          args = function()
            local input = vim.fn.input("Program arguments: ")
            return vim.split(input, " ", { trimempty = true })
          end,
        },
        {
          type = "go",
          name = "Debug with Environment Variables",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          env = {
            GO_ENV = "development",
            DEBUG = "true",
          },
        },
        {
          type = "go",
          name = "Debug Main (auto-find)",
          request = "launch",
          program = function()
            -- Smart main.go finder
            local cwd = vim.fn.getcwd()
            local possible_mains = {
              cwd .. "/main.go",
              cwd .. "/cmd/main.go",
              cwd .. "/cmd/" .. vim.fn.fnamemodify(cwd, ":t") .. "/main.go",
            }

            for _, main_path in ipairs(possible_mains) do
              if vim.fn.filereadable(main_path) == 1 then
                print("Found main.go at: " .. main_path)
                return main_path
              end
            end

            -- If not found, let user specify
            local input = vim.fn.input("Path to main.go: ", "./main.go")
            return input
          end,
          cwd = "${workspaceFolder}",
        },
        {
          type = "go",
          name = "Debug Main (custom path)",
          request = "launch",
          program = function()
            local input = vim.fn.input("Path to main.go: ", "./main.go")
            return input
          end,
          cwd = "${workspaceFolder}",
        },
      }

      -- Merge custom configs with existing ones
      for _, config in ipairs(custom_configs) do
        table.insert(go_configs, config)
      end
      dap.configurations.go = go_configs

      -- Key mappings
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional Breakpoint" })

      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue/Start Debug" })
      vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
      vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "Pause" })
      vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle Debug UI" })
      vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "Eval" })
      vim.keymap.set("v", "<leader>de", dapui.eval, { desc = "Eval" })

      -- Go-specific mappings using dap-go functions
      vim.keymap.set("n", "<leader>dgt", function()
        require("dap-go").debug_test()
      end, { desc = "Debug Go Test" })

      vim.keymap.set("n", "<leader>dgl", function()
        require("dap-go").debug_last_test()
      end, { desc = "Debug Last Go Test" })

      -- Enhanced diagnostic function
      vim.keymap.set("n", "<leader>ddi", function()
        print("=== DAP Go Debug Info ===")

        -- Check if dap-go is loaded
        local dap_go_ok, dap_go = pcall(require, "dap-go")
        if dap_go_ok then
          print("✓ dap-go loaded successfully")
        else
          print("❌ dap-go failed to load: " .. tostring(dap_go))
        end

        -- Check dlv
        local dlv_path = vim.fn.exepath("dlv")
        if dlv_path == "" then
          print("❌ dlv not found in PATH")
          print("   Install with: go install github.com/go-delve/delve/cmd/dlv@latest")
        else
          print("✓ dlv found at: " .. dlv_path)
          -- Test dlv version
          vim.fn.jobstart({ "dlv", "version" }, {
            stdout_buffered = true,
            on_stdout = function(_, data)
              if data and data[1] then
                print("   dlv version: " .. data[1])
              end
            end,
            on_stderr = function(_, data)
              if data and data[1] then
                print("   dlv error: " .. data[1])
              end
            end,
          })
        end

        -- Check Go
        local go_path = vim.fn.exepath("go")
        if go_path == "" then
          print("❌ go not found in PATH")
        else
          print("✓ go found at: " .. go_path)
        end

        -- Check current context
        local current_file = vim.fn.expand("%:p")
        local filetype = vim.bo.filetype
        print("Current file: " .. current_file)
        print("File type: " .. filetype)

        if filetype ~= "go" then
          print("⚠️  Not in a Go file")
        end

        -- Check working directory and go.mod
        print("Working directory: " .. vim.fn.getcwd())
        local go_mod = vim.fn.findfile("go.mod", ".;")
        if go_mod == "" then
          print("⚠️  No go.mod found (run 'go mod init project-name')")
        else
          print("✓ go.mod found: " .. vim.fn.fnamemodify(go_mod, ":p"))
        end

        -- Check DAP configuration
        local go_configs = dap.configurations.go
        if go_configs then
          print("✓ Go debug configurations available: " .. #go_configs)
          for i, config in ipairs(go_configs) do
            print("   " .. i .. ". " .. (config.name or "Unnamed"))
          end
        else
          print("❌ No Go debug configurations found")
        end

        -- Check DAP adapter
        local go_adapter = dap.adapters.go
        if go_adapter then
          print("✓ Go adapter configured")
        else
          print("❌ No Go adapter found")
        end

        -- Check active session
        local session = dap.session()
        if session then
          print("✓ Active DAP session")
        else
          print("ℹ️  No active DAP session")
        end
      end, { desc = "Debug Info" })

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Enhanced error handling
      dap.listeners.after.event_output["dap_go_error"] = function(session, body)
        if body.category == "stderr" and body.output then
          vim.schedule(function()
            if body.output:match("could not launch process") then
              vim.notify(
                "Failed to launch Go process. Check your Go file and working directory.",
                vim.log.levels.ERROR
              )
            elseif body.output:match("build failed") then
              vim.notify("Go build failed. Check for compilation errors.", vim.log.levels.ERROR)
            else
              vim.notify("Debug Output: " .. body.output, vim.log.levels.WARN)
            end
          end)
        end
      end

      -- Set up signs
      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign(
        "DapBreakpointCondition",
        { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
      )
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      sign(
        "DapStopped",
        { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" }
      )
      sign(
        "DapBreakpointRejected",
        { text = "", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
      )

      -- Highlight groups
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e51400" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e4d32" })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#888888" })

      -- Add user commands for convenience
      vim.api.nvim_create_user_command("DapGoTest", function()
        require("dap-go").debug_test()
      end, { desc = "Debug Go test under cursor" })

      vim.api.nvim_create_user_command("DapGoLastTest", function()
        require("dap-go").debug_last_test()
      end, { desc = "Debug last Go test" })
    end,
  },
}
