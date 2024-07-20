local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Ticks! For todo lists
function insertTick()
  vim.api.nvim_put({'✓'}, '', true, true)
end

map('i', '<F5>', '<cmd>lua insertTick()<CR>', opts)
