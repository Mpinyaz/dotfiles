return {
        'akinsho/bufferline.nvim',
        version = '*',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
                require('bufferline').setup {
                        options = {
                                mode = 'tabs',
                                numbers = function(opts)
                                        return string.format('%s', opts.id)
                                end,
                                diagnostics = 'nvim_lsp',
                                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                                        local icon = level:match 'error' and ' ' or ' '
                                        return ' ' .. icon .. count
                                end,
                                show_close_icon = false,
                                max_prefix_length = 8,
                                show_buffer_icons = true,
                                show_buffer_close_icons = false,
                                show_tab_indicators = true,
                                persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
                                sort_by = function(buffer_a, buffer_b)
                                        if not buffer_a and buffer_b then
                                                return true
                                        elseif buffer_a and not buffer_b then
                                                return false
                                        end
                                        return buffer_a.ordinal < buffer_b.ordinal
                                end,
                                offsets = {
                                        {
                                                filetype = 'neo-tree',
                                                text = 'Neo-tree',
                                                highlight = 'Directory',
                                                text_align = 'left',
                                        },
                                },
                        },
                }
        end,
}
