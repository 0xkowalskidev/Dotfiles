{ inputs, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common.nix
    ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "fbcon=rotate:1" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "chuwi";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 3000 8080 ];
  networking.firewall.allowedUDPPorts = [ 3000 8080 ];

  # Power
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.sway}/bin/sway --config=/home/kowalski/Dotfiles/sway/config";
        user = "kowalski";
      };
      default_session = initial_session;
    };
  };

  # Bluetooth 
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  games.minecraft.enable = true;

  programs.sway.enable = true;
  programs.sway.extraOptions = [
    "--config=/home/kowalski/Dotfiles/sway/config"
  ];
  environment.systemPackages = with pkgs; [
    dmenu
  ];

  # Home Manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };

    users = {
      "kowalski" = { ... }: {
        imports = [
          ./home.nix
          inputs.self.outputs.homeManagerModules.default
        ];
      };
    };
  };


  system.stateVersion = "24.11"; # DO NOT CHANGE
}
