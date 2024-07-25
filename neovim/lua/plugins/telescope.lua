require('telescope').setup {
  defaults = {
      file_ignore_patterns = {
            "node_modules/.*",
            "yarn.lock",
            "package-lock.json",
            ".git/.*",
        },
  },
  pickers = {
    find_files = {
      hidden = true
    }
  },
  extensions = {
    },
}

-- Telescope keymappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Find files using Telescope command-line sugar.
map('n', '<A-p>', '<cmd>Telescope find_files<cr>', opts) -- Find files in cur dir
map('n', '<S-p>', '<cmd>Telescope find_files cwd=~/<cr>', opts) -- Find files in home

-- Live grep using Telescope
map('n', '<A-f>', '<cmd>Telescope live_grep<cr>', opts) -- Grep cur dir
map('n', '<S-f>', '<cmd>Telescope live_grep cwd=~/<cr>', opts) -- Grep home
