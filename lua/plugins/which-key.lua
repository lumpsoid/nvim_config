return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup({})

    ---@param opts table
    ---@return function
    MapReg = function(opts)
      ---@param mappings table
      ---@return function
      return function(mappings)
        return require('which-key').register(mappings, opts)
      end
    end

    MapLeaderNormal = MapReg({ mode = 'n', prefix = '<leader>' })

    MapLeaderNormal({
      q = {
        q = { ':q<CR>', 'Quit' },
      }
    })
  end
}
