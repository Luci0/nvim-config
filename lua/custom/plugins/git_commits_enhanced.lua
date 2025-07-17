local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local previewers = require 'telescope.previewers'
local conf = require('telescope.config').values
local Job = require 'plenary.job'
local entry_display = require 'telescope.pickers.entry_display'

local M = {}

M.git_commits_detailed = function()
  Job:new({
    command = 'git',
    args = { 'log', '--pretty=format:%h|%s|%d', '--shortstat' },
    on_exit = function(j)
      local results = {}
      local lines = j:result()
      local commit = nil
      local file_stats = ''

      for _, line in ipairs(lines) do
        if line:match '^%x%x+' then
          if commit then
            table.insert(results, commit .. '|' .. file_stats)
          end
          local sha, msg, ref = line:match '^(%x+)|([^|]+)|?(.*)$'
          local ref_clean = ref and ref:match '%((.-)%)' or ''
          commit = string.format('%s|%s|%s', sha, msg, ref_clean)
          file_stats = ''
        elseif line:match 'file[s]? changed' then
          file_stats = line:gsub(',', ''):gsub('%s+', ' ')
        end
      end
      if commit then
        table.insert(results, commit .. '|' .. file_stats)
      end

      vim.schedule(function()
        pickers
          .new({}, {
            prompt_title = 'Enhanced Git Commits',
            finder = finders.new_table {
              results = results,
              entry_maker = function(entry)
                local sha, msg, ref, stats = entry:match '^(%x+)|([^|]+)|([^|]*)|(.*)$'

                -- Parse stats
                local files, insertions, deletions =
                  stats:match '(%d+) file[s]? changed', stats:match '(%d+) insertion[s]?%(%+%)', stats:match '(%d+) deletion[s]?%(%-%)'
                local stats_display = {}

                if files then
                  table.insert(stats_display, { ' ~' .. files, 'TelescopeResultsSpecialComment' })
                end
                if insertions then
                  table.insert(stats_display, { ' +' .. insertions, 'TelescopeResultsDiffAdd' })
                end
                if deletions then
                  table.insert(stats_display, { ' -' .. deletions, 'TelescopeResultsDiffDelete' })
                end

                local displayer = entry_display.create {
                  separator = ' │ ',
                  items = {
                    { width = 8 },
                    { width = 40 },
                    { width = 15 },
                    { remaining = true },
                  },
                }

                return {
                  value = entry,
                  ordinal = sha .. msg .. stats .. ref,
                  display = function()
                    return displayer {
                      { sha or '', 'TelescopeResultsIdentifier' },
                      { (msg or ''):sub(1, 40), 'TelescopeResultsComment' },
                      stats_display,
                      { ref or '', 'TelescopeResultsComment' },
                    }
                  end,
                }
              end,
            },
            previewer = previewers.new_termopen_previewer {
              get_command = function(entry)
                local sha = entry.value:match '^(%x+)'
                return { 'git', 'show', sha }
              end,
            },
            sorter = conf.generic_sorter {},
          })
          :find()
      end)
    end,
  }):start()
end

return M
