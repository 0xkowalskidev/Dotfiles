{ config, pkgs, ... }:

{
  home.username = "kowalski";
  home.homeDirectory = "/home/kowalski";

  home.stateVersion = "24.05"; # DO NOT CHANGE

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [	
	# Browser
	brave

	# Apps
	spotify
	discord

  	# System
	dmenu
	xclip

	# Utils
  	htop
	acpi # Battery viewer
	
	# Font
	(nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

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

  programs.starship = {
  	enable = true;
  };

  # Editor
  programs.neovim = {
  	enable = true;
	plugins = [ pkgs.vimPlugins.packer-nvim ];
	extraConfig = ''
		set runtimepath^=~/Dotfiles/Neovim
		luafile ~/Dotfiles/Neovim/init.lua
	'';
  };

  programs.home-manager.enable = true;
}
