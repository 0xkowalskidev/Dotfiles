{ inputs, ... }:

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
  networking.hostName = "dopey";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Remote rebuilds
  security.sudo.wheelNeedsPassword = false;

  # Jellyfin
  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;

  # Container Registry
  #virtualisation.docker.enable = true;
  #services.dockerRegistry = {
  #  enable = true;
  #  port = 5000;
  #  enableDelete = true;
  #  enableGarbageCollect = true;
  #};

  # HTTPS for Registry
  #networking.firewall.allowedTCPPorts = [
  #  80
  #  443
  #];

  #services.caddy = {
  #  enable = true;
  #  virtualHosts."registry.0xkowalski.dev".extraConfig = ''
  #    reverse_proxy localhost:5000
  #  '';
  #};

  # Gamejanitor
  services.gamejanitor = {
    enable = true;
    role = "worker";
    grpcPort = 9090;
    controller = "192.168.1.102:9090";
    workerTokenFile = "/etc/gamejanitor/worker-token";
    portRange = {
      start = 28000;
      end = 28999;
    };
    openFirewall = true;
  };

  # User
  users.users.kowalski = {
    isNormalUser = true;
    home = "/home/kowalski";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
