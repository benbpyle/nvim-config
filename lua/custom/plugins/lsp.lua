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
                local map = function(mode, keys, func, desc)
                    vim.keymap.set(mode, keys, func, {
                        buffer = event.buf,
                        desc = 'LSP: ' .. desc
                    })
                end

                map('n', 'gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                map('n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                map('n', 'gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                map('n', '<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                map('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                    '[W]orkspace [S]ymbols')
                map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                map('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                map('n', '<C-o>', vim.lsp.buf.hover, 'Hover Documentation')
                map('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                map('i', '<C-o>', vim.lsp.buf.hover, 'Hover Documentation')
                map('i', '<C-s>', vim.lsp.buf.signature_help, '[S]how Signature')
                map('n', '<leader>h', vim.lsp.buf.signature_help, 'Signature [H]elp')

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

                if vim.lsp.inlay_hint then
                    map('n', '<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end, '[T]oggle Inlay [H]ints')
                end
                -- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                --     map('n', '<leader>th', function()
                --         vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                --     end, '[T]oggle Inlay [H]ints')
                -- end
            end
        })

        -- local capabilities 
        lspconfig = require('lspconfig')
        require('mason').setup()
        -- require('lspconfig').tsserver.setup()
        lspconfig.tsserver.setup {
            on_attach = on_attach,
            flags = lsp_flags,
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true
                    }
                },
                javascript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayVariableTypeHints = true,

                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true
                    }
                },
                completions = {
                    completeFunctionCalls = true
                }
            }
        }

        lspconfig.gopls.setup({
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true
                    },
                    staticcheck = true,
                    gofumpt = true
                }
            }
        })

        lspconfig.rust_analyzer.setup {
            settings = {
                ["rust-analyzer"] = {
                    workspace = {
                        symbol = {
                            search = {
                                kind = "all_symbols"
                            }
                        }
                    }
                }
            }
        }

    end
}}
