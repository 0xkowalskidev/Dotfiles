{ inputs, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ../../common.nix ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;
  services.mullvad-vpn.enable = true;

  # Power
  powerManagement.cpuFreqGovernor = "performance";

  # NAS
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/data" = {
    device = "192.168.1.129:/data";
    fsType = "nfs";
    options = [ "rw" "sync" ];
  };

  # Drives
  fileSystems = {
    "/mnt/secondary" = {
      device = "/dev/disk/by-uuid/4309d554-ce7d-4225-be36-9f7618418310";
      fsType = "ext4";
    };

    "/mnt/tertiary" = {
      device = "/dev/disk/by-uuid/89f9e5df-e79e-4695-a9f3-f67a8bb49cf4";
      fsType = "ext4";
    };
  };

  # Nvidia
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaPersistenced = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Autologin
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "hyprland";
        user = "kowalski";
      };
      default_session = initial_session;
    };
  };

  # Home Manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };

    users = {
      "kowalski" = { ... }: { imports = [ ./home.nix ../../common-home.nix ]; };
    };
  };

  system.stateVersion = "25.05";
}
