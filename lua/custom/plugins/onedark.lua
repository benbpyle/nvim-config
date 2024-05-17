return {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
        require('onedark').setup {
            style = 'dark' -- dark | darker | cool | deep | warm | warmer
        }
        require('onedark').load()
    end
}
