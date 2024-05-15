return {
    'akinsho/bufferline.nvim',
    event = "VeryLazy",
    keys = {{
        "<leader>bp",
        "<Cmd>BufferLineTogglePin<CR>",
        desc = "Toggle Pin"
    }, {
        "<leader>bP",
        "<Cmd>BufferLineGroupClose ungrouped<CR>",
        desc = "Delete Non-Pinned Buffers"
    }, {
        "<leader>bo",
        "<Cmd>BufferLineCloseOthers<CR>",
        desc = "Delete Other Buffers"
    }, {
        "<leader>br",
        "<Cmd>BufferLineCloseRight<CR>",
        desc = "Delete Buffers to the Right"
    }, {
        "<leader>bl",
        "<Cmd>BufferLineCloseLeft<CR>",
        desc = "Delete Buffers to the Left"
    }, {
        "<S-h>",
        "<cmd>BufferLineCyclePrev<cr>",
        desc = "Prev Buffer"
    }, {
        "<S-l>",
        "<cmd>BufferLineCycleNext<cr>",
        desc = "Next Buffer"
    }, {
        "[b",
        "<cmd>BufferLineCyclePrev<cr>",
        desc = "Prev Buffer"
    }, {
        "]b",
        "<cmd>BufferLineCycleNext<cr>",
        desc = "Next Buffer"
    }},
    opts = {
        highlights = {
            separator = {
                guifg = '#073642',
                guibg = '#002b36'
            },
            separator_selected = {
                guifg = '#073642'
            },
            background = {
                guifg = '#657b83',
                guibg = '#002b36'
            },
            buffer_selected = {
                guifg = '#fdf6e3',
                gui = "bold"
            },
            fill = {
                guibg = '#073642'
            }
        },
        options = {
            -- stylua: ignore
            mode = "buffer",
            separator_style = 'thick',
            -- always_show_bufferline = false,
            show_buffer_close_icons = false,
            show_close_icon = false,
            color_icons = true,

            offsets = {{
                filetype = "neo-tree",
                text = "Neo-tree",
                highlight = "Directory",
                text_align = "left"
            }}
        }
    },
    config = function(_, opts)
        require("bufferline").setup(opts)

        vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
        vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})

        -- Fix bufferline when restoring a session
        vim.api.nvim_create_autocmd("BufAdd", {
            callback = function()
                vim.schedule(function()
                    pcall(nvim_bufferline)
                end)
            end
        })
    end
}
