{ config, pkgs, ... }:

{
  home.username = "kowalski";
  home.homeDirectory = "/home/kowalski";

  home.stateVersion = "24.05"; # DO NOT CHANGE

  home.packages = with pkgs; [
  	htop
	xclip
	dmenu
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  programs.git = {
  	enable = true;
	userEmail = "0xkowalskiaudit@gmail.com";
	userName = "0xkowalski1";
  };

  programs.home-manager.enable = true;
}
