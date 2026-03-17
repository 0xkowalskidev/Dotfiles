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
    role = "worker";
    grpcPort = 9090;
    controller = "192.168.1.102:9090";
    workerTokenFile = "/etc/gamejanitor/worker-token";
    portRange = {
      start = 27000;
      end = 27999;
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
