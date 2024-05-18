return {{ -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = { -- Automatically install LSPs and related tools to stdpath for Neovim
    {
        'williamboman/mason.nvim',
        config = true
    }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim', 'WhoIsSethDaniel/mason-tool-installer.nvim', -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    {
        'j-hui/fidget.nvim',
        opts = {}
    }, -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    {
        'folke/neodev.nvim',
        opts = {}
    }},
    config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', {
                clear = true
            }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set('n', keys, func, {
                        buffer = event.buf,
                        desc = 'LSP: ' .. desc
                    })
                end

                map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                map('K', vim.lsp.buf.hover, 'Hover Documentation')
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                map('<leader>h', vim.lsp.buf.signature_help, 'Signature [H]elp')

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.server_capabilities.documentHighlightProvider then
                    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', {
                        clear = false
                    })
                    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight
                    })

                    vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', {
                            clear = true
                        }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds {
                                group = 'kickstart-lsp-highlight',
                                buffer = event2.buf
                            }
                        end
                    })
                end

                if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    map('<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end, '[T]oggle Inlay [H]ints')
                end
            end
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        -- local servers = {
        --     gopls = {},
        --     rust_analyzer = {},
        --     tsserver = {},
        --     lua_ls = {
        --         -- cmd = {...},
        --         -- filetypes = { ...},
        --         -- capabilities = {},
        --         settings = {
        --             Lua = {
        --                 completion = {
        --                     callSnippet = 'Replace'
        --                 }
        --             }
        --         }
        --     }
        -- }

        require('mason').setup()
        -- require('lspconfig').tsserver.setup()
        require('lspconfig').tsserver.setup {
            on_attach = on_attach,
            flags = lsp_flags,
            settings = {
                completions = {
                    completeFunctionCalls = true
                }
            }
        }

        -- local ensure_installed = vim.tbl_keys(servers or {})
        -- vim.list_extend(ensure_installed, {'stylua' -- Used to format Lua code
        -- })
        -- require('mason-tool-installer').setup {
        --     ensure_installed = ensure_installed
        -- }

        -- require('mason-lspconfig').setup {
        --     handlers = {function(server_name)
        --         local server = servers[server_name] or {}
        --         server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        --         require('lspconfig')[server_name].setup(server)
        --     end}
        -- }
    end
}}
