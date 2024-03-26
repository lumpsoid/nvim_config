return {
  'gelguy/wilder.nvim',
  config = function()
    vim.api.nvim_exec([[
      call wilder#setup({
        \ 'modes': [':', '/', '?'],
        \ 'next_key': '<Tab>',
        \ 'previous_key': '<S-Tab>',
        \ })
    ]], false)
  end
}
