return {
        opts = {
                auto_enable = true,
                auto_resize_height = true,
                preview = {
                        auto_preview = true,
                        win_height = 12,
                        win_vheight = 12,
                        delay_syntax = 80,
                        border = { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' },
                        show_title = false,
                        should_preview_cb = function(bufnr, qwinid)
                                local ret = true
                                local bufname = vim.api.nvim_buf_get_name(bufnr)
                                local fsize = vim.fn.getfsize(bufname)
                                if fsize > 100 * 1024 then
                                        -- skip file size greater than 100k
                                        ret = false
                                elseif bufname:match '^fugitive://' then
                                        -- skip fugitive buffer
                                        ret = false
                                end
                                return ret
                        end,
                },
        },
        'kevinhwang91/nvim-bqf', -- Better quickfix window,
        ft = 'qf',
        keys = { '<leader>cql', '<cmd>copen<cr>', desc = 'Open Quickfix list' },
        dependencies = {
                'junegunn/fzf',
        },
}
