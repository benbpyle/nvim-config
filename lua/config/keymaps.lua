-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>", {
    silent = true
})
vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>", {
    silent = true
})
vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>", {
    silent = true
})
vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>", {
    silent = true
})
vim.keymap.set("n", "<C-\\>", "<Cmd>NvimTmuxNavigateLastActive<CR>", {
    silent = true
})
vim.keymap.set("n", "<C-Space>", "<Cmd>NvimTmuxNavigateNavigateNext<CR>", {
    silent = true
})

vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})

-- Toggle autocomplete
vim.g.cmptoggle = true

local cmp = require("cmp")
cmp.setup({
    enabled = function()
        return vim.g.cmptoggle
    end
})
vim.keymap.set("n", "<leader>ux", "<cmd>lua vim.g.cmptoggle = not vim.g.cmptoggle<CR>", {
    desc = "toggle nvim-cmp"
}) -- Toggle autocomplete

vim.keymap.set("n", "gL", "<cmd>lua vim.lsp.buf.hover()<CR>", {
    desc = "Show buffer hover"
})

