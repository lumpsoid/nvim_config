vim.g.magma_image_provider = "none"
vim.g.magma_automatically_open_output = false

vim.keymap.set('n', '<leader>rx', "<cmd>lua vim.api.nvim_exec('MagmaEvaluateOperator', true)<cr>", {desc = 'Magma: eval operator'})
vim.keymap.set('n', '<leader>rl', '<cmd>MagmaEvaluateLine<cr>', {desc = 'Magma: run line'})
vim.keymap.set('x', '<leader>r', ':<C-u>MagmaEvaluateVisual<cr>', {desc = 'Magma: run visual'})
vim.keymap.set('n', '<leader>rb', 'vip:<C-u>MagmaEvaluateVisual<cr>', {desc = 'Magma: run current block'})
vim.keymap.set('n', '<leader>rr', ':MagmaReevaluateCell<cr>', {desc = 'Magma: Re-evaluate cell'})
vim.keymap.set('n', '<leader>ro', ':MagmaShowOutput<cr>', {desc = 'Magma: Show output'})
vim.keymap.set('n', '<leader>q', ':noautocmd MagmaEnterOutput<cr>', {desc = 'Magma: Enter output'})

--nnoremap <silent> <LocalLeader>rd :MagmaDelete<CR>
--nnoremap <silent> <LocalLeader>rq :noautocmd MagmaEnterOutput<CR>
