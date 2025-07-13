vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

local state = {
  floating = {
    [1] = { buf = -1, win = -1 },
    [2] = { buf = -1, win = -1 },
    [3] = { buf = -1, win = -1 },
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Define window configuration
  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local function toggle_terminal(id)
  if not state.floating[id] then
    vim.notify('Invalid terminal id: ' .. tostring(id), vim.log.levels.ERROR)
    return
  end

  local term = state.floating[id]

  if not vim.api.nvim_win_is_valid(term.win) then
    -- Create and open window
    state.floating[id] = create_floating_window { buf = term.buf }

    -- If the buffer isn't already a terminal, open terminal
    if vim.bo[state.floating[id].buf].buftype ~= 'terminal' then
      vim.cmd 'terminal'
    end
  else
    -- Hide window
    vim.api.nvim_win_hide(term.win)
  end
end

-- Create commands and keymaps for each terminal
for i = 1, 3 do
  local cmd_name = 'Floaterminal' .. i
  local key = '<leader>t' .. i

  vim.api.nvim_create_user_command(cmd_name, function()
    toggle_terminal(i)
  end, {})
  vim.keymap.set({ 'n', 't' }, key, function()
    toggle_terminal(i)
  end, { desc = 'Toggle Floating Terminal ' .. i })
end
