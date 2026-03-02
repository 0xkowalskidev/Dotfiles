{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "dopey";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Minecraft Server
  users.groups.minecraft = { };
  users.users.minecraft = {
    extraGroups = [ "nfsusers" ];
    isSystemUser = true;
    group = "minecraft";
  };

  users.groups.nfsusers = {
    gid = 1000;
  };

  # Jellyfin
  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;

  # Container Registry
  virtualisation.docker.enable = true;
  services.dockerRegistry = {
    enable = true;
    port = 5000;
  };

  # HTTPS for Registry
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services.caddy = {
    enable = true;
    virtualHosts."registry.0xkowalski.dev".extraConfig = ''
      reverse_proxy localhost:5000
    '';
  };

  # User
  users.users.kowalski = {
    isNormalUser = true;
    home = "/home/kowalski";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
