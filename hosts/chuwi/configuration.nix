{ inputs, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ../../common.nix ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "video=DSI-1:panel_orientation=right_side_up" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "chuwi";
  networking.networkmanager.enable = true;
  services.mullvad-vpn.enable = true;

  # Power
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Startup optimizations
  systemd.services.NetworkManager-wait-online.enable = false;

  # Bluetooth 
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

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
