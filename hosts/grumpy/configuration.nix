{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    inputs.gamejanitor.nixosModules.default
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "grumpy";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Remote rebuilds
  security.sudo.wheelNeedsPassword = false;

  # Gamejanitor
  services.gamejanitor = {
    enable = true;
    port = 8080;
  };

  networking.firewall = {
    allowedTCPPorts = [
      8080  # Gamejanitor Web UI
      7777  # Terraria
      25565 # Minecraft
      25575 # Palworld RCON
      27015 # CS2 / Garry's Mod RCON
      27020 # ARK RCON
      28016 # Rust RCON
    ];
    allowedUDPPorts = [
      2456  # Valheim game
      2457  # Valheim query
      7777  # ARK game
      8211  # Palworld game
      27015 # ARK query / CS2 / Garry's Mod
      28015 # Rust game
      28017 # Rust query
    ];
    allowedTCPPortRanges = [
      { from = 49152; to = 65535; }
    ];
    allowedUDPPortRanges = [
      { from = 49152; to = 65535; }
    ];
  };

  # User
  users.users.kowalski = {
    isNormalUser = true;
    home = "/home/kowalski";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
