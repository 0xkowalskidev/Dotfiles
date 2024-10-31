{ inputs, pkgs, config, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common.nix
    ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # Networking
  networking.hostName = "laptop";
  networking.networkmanager.enable = true;

  # Power
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Bluetooth 
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  programs.sway.enable = true;
  programs.sway.extraOptions = [
    "--config=/home/kowalski/Dotfiles/sway/config"
  ];

  projects.container-orchestrator.enable = true;
  games.minecraft.enable = true;


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


  system.stateVersion = "24.05"; # DO NOT CHANGE
}
