return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {'hrsh7th/cmp-nvim-lsp', {
        'L3MON4D3/LuaSnip',
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        dependencies = {'rafamadriz/friendly-snippets', 'saadparwaiz1/cmp_luasnip'},
        config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
        end
    }},
    config = function()
        local kind_icons = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = ""
        }
        --         -- See `:help cmp`
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}

        cmp.setup {
            preselect = 'item',
            completion = {
                completeopt = 'menu,menuone,noinsert'
            },
            window = {
                documentation = {
                    border = "rounded",
                    winhighlight = "Normal:CmpNormal"
                },
                completion = {
                    border = "rounded",
                    winhighlight = "Normal:CmpNormal"
                }
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete {},
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true
                },
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, {'i', 's'}),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, {'i', 's'})
            },
            sources = {
                {
                    name = "nvim_lsp"
                },
                {
                    name = 'luasnip'
                },
                formatting = {
                    format = function(entry, vim_item)
                        -- Kind icons
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
                        vim_item.menu = ({
                            nvim_lsp = '[lsp]',
                            luasnip = '[snip]',
                            buffer = '[buf]',
                            path = '[path]'
                        })[entry.source.name]
                        return vim_item
                    end
                }
            }
        }
    end
}
