-- unmaintained 'phaazon/hop.nvim',
return {
  'smoka7/hop.nvim',
  version = 'v2',
  opts = {
  --    keys = 'asdfghjkl',
      quit_key = '<ESC>',
      jump_on_sole_occurrence = false,
      smartcase = true,
      uppercase_labels = false,
    },
  config = function()
    require('hop').setup()
    -- keymaps
  end
}
