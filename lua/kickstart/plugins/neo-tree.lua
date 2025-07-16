-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- Show all filtered items
        hide_dotfiles = false, -- Show dotfiles
        hide_gitignored = false, -- Optional: show gitignored files
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['-'] = 'navigate_up', -- Optional: adds manual parent dir nav
        },
      },
    },
  },
}
