local M = {}

-- Open selected file in a new tmux window
function M.open_in_tmux()
  local entry = require('telescope.actions.state').get_selected_entry()
  if not entry then
    return
  end

  -- Get the path of the selected file
  local path = entry.path

  -- Run the tmux command to open a new window and open the file
  vim.fn.system(string.format("tmux new-window 'nvim %s'", path))
end

return M
