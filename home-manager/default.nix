{ pkgs, ... }:

{
  imports = [
    ./programs/spotify-player.nix
    ./programs/brave.nix
    ./programs/neovim.nix
    ./programs/alacritty.nix
    ./programs/bash.nix
    ./programs/git.nix
  ];

  programs.home-manager.enable = true;

  home.username = "kowalski";
  home.homeDirectory = "/home/kowalski";

  home.packages = with pkgs; [
    # Apps
    discord
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
    sloc
    gnumake
  ];

  home.stateVersion = "24.05"; # DO NOT CHANGE
}
