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

  services.minecraft-server = {
    enable = true;
    openFirewall = true;
    eula = true;
    dataDir = "/mnt/data/minecraft-server";
    jvmOpts = "-Xmx6G -Xms6G -Djava.net.preferIPv4Stack=true";
    declarative = true;
    serverProperties = {
      difficulty = 3;
      max-players = 10000;
      motd = "Jonathan Wickes.";
      view-distance = 64;
    };
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
      @push {
        method POST PUT PATCH DELETE
        not remote_ip 192.168.1.17
      }
      respond @push 403
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
