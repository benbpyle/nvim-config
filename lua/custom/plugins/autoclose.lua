return {
    'm4xshen/autoclose.nvim',
    enable = false,
    config = function(_, opts)
        require("autoclose").setup({
            options = {
               disabled_filetypes = { "text", "markdown" },
            },
         })    

    end,
  
}