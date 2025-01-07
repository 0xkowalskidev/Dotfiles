{ pkgs, ... }:

{
  imports = [
    ./programs/spotify-player.nix
    ./programs/brave.nix
    ./programs/neovim.nix
    ./programs/alacritty.nix
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/discord.nix
  ];

  programs.home-manager.enable = true;

  home.username = "kowalski";
  home.homeDirectory = "/home/kowalski";

  home.packages = with pkgs; [
    # Utils
    btop
    acpi # Battery viewer
    bat # Better Cat
    jq # Command Line Json Proccesor
    geeqie # Image viewer
    cloc # Count lines of code
    ncdu # Disk usage analysis
    gnumake
    tt # Typespeed test
    nmap
    tree
    fastfetch
    cpufetch
    qemu
    #quickemu
    inetutils
    firefox
    openvpn
    dig
    wireshark
    pass
    gnupg
    tcpdump
    calc
    unzip
    john
    hashid
    gobuster
    thc-hydra
    sqlmap
    poppler_utils
    exiftool
  ];

  home.stateVersion = "24.05"; # DO NOT CHANGE
}
