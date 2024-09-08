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

  # Disable trackpad by default
  #  services.xserver.displayManager.sessionCommands = ''
  #   xinput disable "bcm5974"
  #   unclutter &
  # '';

  # Script for toggling trackpad
  environment.systemPackages = with pkgs; [
    unclutter # For hiding cursor

    (pkgs.writeScriptBin "toggleTrackpad" ''
      #!/bin/sh
      TRACKPAD_NAME="bcm5974" 
      TRACKPAD_ID=$(xinput list --id-only "$TRACKPAD_NAME")

      if [ "$(xinput list-props "$TRACKPAD_ID" | grep 'Device Enabled' | awk '{print $4}')" -eq 1 ]; then
          xinput disable "$TRACKPAD_ID"
          unclutter &
      else
          xinput enable "$TRACKPAD_ID"
          pkill unclutter
      fi
    '')
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


  system.stateVersion = "24.05"; # DO NOT CHANGE
}
