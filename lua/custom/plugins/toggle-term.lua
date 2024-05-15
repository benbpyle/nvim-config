return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({vim.keymap.set("n", "<leader>tt", "<Esc>:ToggleTerm direction=float<CR>", {
            silent = true
        })});
    end
}
 