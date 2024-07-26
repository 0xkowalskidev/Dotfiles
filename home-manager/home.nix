{ config, pkgs, ... }:

{
  home.username = "kowalski";
  home.homeDirectory = "/home/kowalski";

  home.stateVersion = "24.05"; # DO NOT CHANGE

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [	
        # Apps
	discord
        spotify-player # CLI Spotify
        prismlauncher # Minecraft

  	# System
	dmenu
	xclip
        mdcat # Markdown cat
        jq # Command Line Json Proccesor
        feh # Image viewer
        cloc # Count lines of code
        ripgrep # Used by nvim telescope

	# Utils
  	htop
	acpi # Battery viewer

        # Languages/LSPs
        ## Lua
        lua-language-server
        ## Go
        go
        gopls # Lsp
        air # Dev Server
        # Java
        openjdk21
        # Html, CSS, JSON
        vscode-langservers-extracted
        # Javascript/Typescript
        nodejs
        typescript
        typescript-language-server

	# Font
	(nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # Notifications ( Required by some apps such as spotify-player ) 
  # Don't actually want notifications so will hide them
services.dunst = {
  enable = true;
  settings = {
          global = {
                  width = 0;
                  height = 0;
                  transparency = 100;
                  geometry = "0x0";
                  padding = 0;
                  frame_width = 0;
          }; 
  };
};

  # Browser
  programs.chromium = {
          enable = true;
          package = pkgs.brave;
          extensions = [
                # Vimium
                { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
                # Video Speed Controller
                { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; }
                # Remove Youtube Shorts
                { id = "mgngbgbhliflggkamjnpdmegbkidiapm"; }
                # UBlock Origin
                { id = "epcnnfbjfcgphgdmggkamkmgojdagdnn"; }
                # Sponsor Block
                { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
          ];
  };
 
  # Git
  programs.git = {
  	enable = true;
	userEmail = "0xkowalskiaudit@gmail.com";
	userName = "0xkowalski1";
  };

  # Bash
  programs.bash = {
  	enable = true;
	initExtra = ''
		ssh-add ~/.ssh/github_rsa
		clear
	'';
  };

  # Font
  fonts.fontconfig.enable = true;

  # Terminal
  programs.alacritty = {
  	enable = true;
	settings = { 
		font = {
			normal = {
				family = "FiraCode Nerd Font Mono";
				style = "regular";
			};
			size = 12.0;
		};
	};
  };

  # Editor
  programs.neovim = {
  	enable = true;
	plugins = [ pkgs.vimPlugins.packer-nvim ];
	extraConfig = ''
		set runtimepath^=~/Dotfiles/neovim
		luafile ~/Dotfiles/neovim/init.lua
	'';
  };

  programs.home-manager.enable = true;
}
