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
        r2modman # Unoffocial thunderstore mod manager

        # Utils
  	btop
	acpi # Battery viewer
        bat # Better Cat
        jq # Command Line Json Proccesor
        feh # Image viewer
        cloc # Count lines of code
        dust # Disk usage analysis
        gnumake
        sloc 
        ripgrep # Used by nvim telescope

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
        air # Dev Server
        templ # Templating

        # Java
        openjdk21
        # Html, CSS, JSON
        vscode-langservers-extracted
        # Javascript/Typescript
        nodejs
        typescript
        typescript-language-server
        # Nix
        nixd # Lsp

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
                # Return Youtube Dislikes
                { id  = "gebbhagfogifgggkldgodflihgfeippi"; }
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

    # Direnv
  programs.direnv = {
      enable = true;
      enableBashIntegration = true; 
      nix-direnv.enable = true;
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
