local colors = require('solarized-osaka.colors').setup()

return {
        'b0o/incline.nvim',
        dependencies = {
                'nvim-tree/nvim-web-devicons',
                'craftzdog/solarized-osaka.nvim',
        },
        opts = {
                debounce_threshold = {
                        falling = 50,
                        rising = 10,
                },
                hide = {
                        cursorline = true,
                        focused_win = false,
                        only_win = false,
                },
                highlight = {
                        groups = {
                                InclineNormal = {
                                        guibg = colors.magenta500,
                                        guifg = colors.base04,
                                },
                                InclineNormalNC = {
                                        guifg = colors.violet500,
                                        guibg = colors.base03,
                                },
                        },
                },
                ignore = {
                        buftypes = 'special',
                        filetypes = {},
                        floating_wins = true,
                        unlisted_buffers = true,
                        wintypes = 'special',
                },
                window = {
                        margin = {
                                horizontal = 1,
                                vertical = 1,
                        },
                        options = {
                                signcolumn = 'no',
                                wrap = false,
                        },
                        padding = 1,
                        padding_char = ' ',
                        placement = {
                                horizontal = 'right',
                                vertical = 'top',
                        },
                        width = 'fit',
                        winhighlight = {
                                active = {
                                        EndOfBuffer = 'None',
                                        Normal = 'InclineNormal',
                                        Search = 'None',
                                },
                                inactive = {
                                        EndOfBuffer = 'None',
                                        Normal = 'InclineNormalNC',
                                        Search = 'None',
                                },
                        },
                        zindex = 50,
                },
                render = function(props)
                        local devicons = require 'nvim-web-devicons'
                        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                        if filename == '' then
                                filename = '[No Name]'
                        end
                        local ft_icon, ft_color = devicons.get_icon_color(filename)

                        local function get_git_diff()
                                local icons = { removed = '', changed = '', added = '' }
                                local signs = vim.b[props.buf].gitsigns_status_dict
                                local labels = {}
                                if signs == nil then
                                        return labels
                                end
                                for name, icon in pairs(icons) do
                                        if tonumber(signs[name]) and signs[name] > 0 then
                                                table.insert(labels,
                                                        { icon .. signs[name] .. ' ', group = 'Diff' .. name })
                                        end
                                end
                                if #labels > 0 then
                                        table.insert(labels, { '┊ ' })
                                end
                                return labels
                        end

                        local function get_diagnostic_label()
                                local icons = { error = '', warn = '', info = '', hint = '' }
                                local label = {}

                                for severity, icon in pairs(icons) do
                                        local n = #vim.diagnostic.get(props.buf,
                                                { severity = vim.diagnostic.severity[string.upper(severity)] })
                                        if n > 0 then
                                                table.insert(label,
                                                        { icon .. n .. ' ', group = 'DiagnosticSign' .. severity })
                                        end
                                end
                                if #label > 0 then
                                        table.insert(label, { '┊ ' })
                                end
                                return label
                        end

                        return {
                                -- { get_diagnostic_label() },
                                -- { get_git_diff() },
                                { (ft_icon or '') .. ' ', guifg = ft_color, guibg = 'none' },
                                { filename .. ' ', gui = vim.bo[props.buf].modified and 'bold,italic' or 'bold' },
                                { '┊  ' .. vim.api.nvim_win_get_number(props.win), group = 'DevIconWindows' },
                        }
                end,
        },
}
