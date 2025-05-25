{ pkgs, config, lib, ... }:


{
  options =
    {
      neovim.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Neovim";
      };
    };


  config = lib.mkIf config.neovim.enable {
    home.packages = with pkgs; [
      ripgrep # Used by nvim telescope
      xclip

      # Languages/LSPs
      # C
      gcc
      # HTMX
      htmx-lsp
      # Tailwind
      tailwindcss
      tailwindcss-language-server
      ## Lua
      lua-language-server
      ## Go
      go
      gopls # Lsp
      ## Odin
      odin
      ols # LSP
      # Html, CSS, JSON
      vscode-langservers-extracted
      # Javascript/Typescript
      nodejs
      typescript
      typescript-language-server
      # Nix
      nil # Lsp
      nixpkgs-fmt # Formatting
      # Dev Tools
      reflex
    ];

    programs.neovim = {
      enable = true;
      plugins = [ pkgs.vimPlugins.packer-nvim ];
      extraConfig = ''
        		set runtimepath^=~/Dotfiles/neovim
        		luafile ~/Dotfiles/neovim/init.lua
        	'';
    };
  };
}
