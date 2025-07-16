vim.o.winbar = '%=%f'

vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>gi', { noremap = true, silent = true })
vim.keymap.set('v', '<C-s>', '<Esc>:w<CR>gv', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>hh', function()
  vim.ui.input({ prompt = 'Diff against branch: ' }, function(branch)
    if branch and #branch > 0 then
      vim.cmd('DiffviewOpen ' .. branch)
    else
      print 'No branch entered'
    end
  end)
end, { desc = 'Diff current branch against input branch' })
