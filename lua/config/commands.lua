local dart = require('utils.dart')
local extract = require('utils.extract_note')

vim.api.nvim_create_user_command('DartCreateBarrelFile', dart.create_barrel_file, {})

-- Create the user command
vim.api.nvim_create_user_command("ExtractNote", extract.extract_note_from_cursor, {
  desc = "Extract note from current cursor position and create new note"
})
