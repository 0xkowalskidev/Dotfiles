return require('packer').startup(function(use)
  -- Package Manager  
  use 'wbthomason/packer.nvim'
   
  -- Theme
  use 'navarasu/onedark.nvim'

  -- Telescope
  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.5',
    requires = { 'nvim-lua/plenary.nvim' } 
  }

  -- Harpoon
  use {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { {"nvim-lua/plenary.nvim"}, {"nvim-telescope/telescope.nvim"} }
  }

  -- Lsp
  use { 
        "neovim/nvim-lspconfig",
  }

end)

