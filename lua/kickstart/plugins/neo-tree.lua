-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
    'nvim-neo-tree/neo-tree.nvim',

    init = function()
        if vim.fn.argc(-1) == 1 then
            local stat = vim.loop.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
                require("neo-tree").setup({
                    filesystem = {
                        hijack_netrw_behavior = "open_current"
                    }
                })
            end
        end
    end,

    version = '*',
    dependencies = {'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim'},
    cmd = 'Neotree',
    keys = {{'\\', ':Neotree reveal<CR>', {
        desc = 'NeoTree reveal'
    }}},
    opts = {
        filesystem = {
            window = {
                mappings = {
                    ['\\'] = 'close_window'
                }
            },
            filtered_items = {
                visible = true,
                show_hidden_count = true,
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_by_name = {
                    -- '.git',
                    -- '.DS_Store',
                    -- 'thumbs.db',
                },
                never_show = {}
            }
        }
    }
}
