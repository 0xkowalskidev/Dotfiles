{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    #inputs.gamejanitor.nixosModules.default
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "dopey";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 9090 ];
  networking.firewall.allowedTCPPortRanges = [{ from = 27000; to = 27999; }];
  networking.firewall.allowedUDPPortRanges = [{ from = 27000; to = 27999; }];

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
  #  virtualHosts."registry.warsmite.com".extraConfig = ''
  #    reverse_proxy localhost:5000
  #  '';
  #};

  #services.gamejanitor = {
  #  enable = true;
  #  controller = false;
  #  worker = true;
  #  bindAddress = "0.0.0.0";
  #  containerRuntime = "docker";
  #  grpcPort = 9090;
  #  controllerAddress = "192.168.1.102:9090";
  #  workerTokenFile = "/etc/gamejanitor/worker-token";
  #  settings = {
  #    port_range_start = 28000;
  #    port_range_end = 28999;
  #  };
  #  openFirewall = true;
  #};

  # User
  users.users.warsmite = {
    isNormalUser = true;
    home = "/home/warsmite";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
