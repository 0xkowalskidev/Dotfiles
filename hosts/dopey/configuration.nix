{ inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ../../common.nix ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "dopey";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  # NAS
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/data" = {
    device = "192.168.1.129:/data";
    fsType = "nfs";
    options = [ "rw" "sync" ];
  };

  # Minecraft Server
  users.users.minecraft = { extraGroups = [ "nfsusers" ]; };

  users.groups.nfsusers = { gid = 1000; };

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

  # User
  users.users.kowalski = {
    isNormalUser = true;
    home = "/home/kowalski";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
