local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values

local function diff_with_branch_picker()
  vim.fn.system 'git fetch' -- Optional: update branches

  -- Get all local and remote branches
  local branches = vim.fn.systemlist "git branch --all --format='%(refname:short)'"

  pickers
    .new({}, {
      prompt_title = 'Select Git Branch to Diff Against',
      finder = finders.new_table {
        results = branches,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        local function on_select()
          local selection = action_state.get_selected_entry()
          if not selection then
            return
          end
          actions.close(prompt_bufnr)

          local branch = selection[1]
          -- Remove 'remotes/' prefix if present
          branch = branch:gsub('^remotes/', '')
          vim.cmd('DiffviewOpen ' .. branch)
        end

        map('i', '<CR>', on_select)
        map('n', '<CR>', on_select)
        return true
      end,
    })
    :find()
end

vim.keymap.set('n', '<leader>hh', diff_with_branch_picker, { desc = 'Diff with selected branch' })
