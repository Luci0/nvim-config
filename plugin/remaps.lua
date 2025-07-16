vim.o.winbar = '%=%f'

vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>gi', { noremap = true, silent = true })
vim.keymap.set('v', '<C-s>', '<Esc>:w<CR>gv', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>hk', function()
  require('telescope.builtin').git_commits()
end, { desc = 'List Git commits in current branch' })
