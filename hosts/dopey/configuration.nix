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

  # Container Registry (no auth - handled by Caddy)
  virtualisation.docker.enable = true;
  services.dockerRegistry = {
    enable = true;
    port = 5000;
  };

  # HTTPS for Registry (public pull, private push)
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services.caddy = {
    enable = true;
    virtualHosts."registry.0xkowalski.dev".extraConfig = ''
      header Docker-Distribution-Api-Version "registry/2.0"

      @write method PUT POST PATCH DELETE
      basic_auth @write {
        kowalski $2a$14$xypqLlDEIF0N0GxRsr127eWIKEG3dhL0ddzqa0uR5Zc6RvGYVovhu
      }

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
