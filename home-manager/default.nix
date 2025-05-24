{ pkgs, inputs, ... }:

{
  imports = [
    ./programs/spotify-player.nix
    ./programs/brave.nix
    ./programs/neovim.nix
    ./programs/alacritty.nix
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/discord.nix
    ./programs/freecad.nix
    ./programs/bambu-studio.nix
  ];

  programs.home-manager.enable = true;

  home.username = "kowalski";
  home.homeDirectory = "/home/kowalski";

  programs.tmux.enable = true;
  programs.tmux.newSession = true;

  home.packages = with pkgs; [
    jellyfin-media-player #Jellyfin client
    qbittorrent
    mpv
    mullvad-browser
    monero-gui
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
    evince # pdf reader
    nmap
    tree
    fastfetch
    cpufetch
    qemu
    quickemu
    swtpm
    spicy
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
    rar
    tldr
    inputs.nopswd.packages.x86_64-linux.default
  ];

  home.stateVersion = "24.05"; # DO NOT CHANGE
}
