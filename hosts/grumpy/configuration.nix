{
  inputs,
  ...
}:

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

  services.gamejanitor = {
    enable = true;
    controller = false;
    worker = true;
    bindAddress = "0.0.0.0";
    containerRuntime = "docker";
    grpcPort = 9090;
    controllerAddress = "192.168.1.102:9090";
    workerTokenFile = "/etc/gamejanitor/worker-token";
    settings = {
      port_range_start = 29000;
      port_range_end = 29999;
    };
    openFirewall = true;
  };

  # User
  users.users.warsmite = {
    isNormalUser = true;
    home = "/home/warsmite";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
