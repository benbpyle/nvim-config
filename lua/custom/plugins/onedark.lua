return {
    'navarasu/onedark.nvim',
    priority = 1001,
    config = function()
        require('onedark').setup {
            style = 'warm' -- dark | darker | cool | deep | warm | warmer
        }
        require('onedark').load()
    end
}
