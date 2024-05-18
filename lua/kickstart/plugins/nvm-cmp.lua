return {{
    "hrsh7th/nvim-cmp",
    dependencies = {'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path', 'hrsh7th/cmp-buffer'},
    config = function()
        local cmp = require('cmp')

        cmp.setup {
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered()
            },

            -- You should specify your *installed* sources.

            mapping = cmp.mapping.preset.insert {
                ['<CR>'] = cmp.mapping.confirm {
                    select = true
                },
                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                ['<C-Space>'] = cmp.mapping.complete {}
            },
            sources = cmp.config.sources({{
                name = 'nvim_lsp'
            } -- {
            --     name = 'luasnip'
            -- } 
            }, {
                name = 'buffer'
            })

        }
    end

}}
