return require('packer').startup(function(use)
        -- Package Manager
        use "wbthomason/packer.nvim"

        -- Theme
        use "navarasu/onedark.nvim"

        -- TreeSitter
        use {
                'nvim-treesitter/nvim-treesitter',
                run = ':TSUpdate'
        }

        -- Telescope
        use {
                "nvim-telescope/telescope.nvim", tag = "0.1.5",
                requires = { "nvim-lua/plenary.nvim" }
        }

        -- Harpoon
        use {
                "ThePrimeagen/harpoon",
                branch = "harpoon2",
                requires = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope.nvim" } }
        }

        -- Lsp
        use "neovim/nvim-lspconfig"
        use "hrsh7th/nvim-cmp"     -- Autocompletion plugin
        use "hrsh7th/cmp-nvim-lsp" -- LSP source for nvim-cmp
        use "hrsh7th/cmp-buffer"   -- Buffer completions
        use "hrsh7th/cmp-path"     -- Path completions
        use "hrsh7th/cmp-cmdline"  -- Command line completions
        use 'hrsh7th/cmp-vsnip'    -- Snippets
        use 'hrsh7th/vim-vsnip'
end)
