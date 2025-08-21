return {
	"mfussenegger/nvim-dap",
	keys = {
		{
			"<leader>Dc",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<leader>Dsi",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<leader>DsO",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<leader>Dso",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<leader>Db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
		{
			"<leader>DB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Set Conditional Breakpoint",
		},
		{
			"<leader>Dt",
			function()
				require("dapui").toggle()
			end,
			desc = "Debug: Toggle UI",
		},
		{
			"<leader>Dl",
			function()
				require("dap").run_last()
			end,
			desc = "Debug: Run Last Configuration",
		},
	},
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

		-- optional
		-- require('mason-nvim-dap').setup {
		--     automatic_installation = true,
		--     handlers = {},
		--     ensure_installed = {
		--     },
		-- }

		-- Dap UI setup
		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
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

		-- Automatically open/close DAP UI
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Setup virtual text to show variable  inline
		require("nvim-dap-virtual-text").setup({})

		require("dap-go").setup({
			delve = {
				-- Path to delve executable, only needed if you're not using mason-nvim-dap
				path = vim.fn.exepath("dlv") ~= "" and vim.fn.exepath("dlv") or "/opt/homebrew/bin/dlv",

				-- On Windows delve must be run attached or it crashes.
				-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
				-- detached = vim.fn.has 'win32' == 0,
			},
		})
	end,
}
