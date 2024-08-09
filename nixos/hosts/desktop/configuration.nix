{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common.nix
    ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

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

  # GPU
  hardware.nvidia = {
    modesetting.enable = true;

    nvidiaPersistenced = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # Nix-gaming cache
  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };

  # Enable multi monitor
  services.xserver = {
  enable = true;
  videoDrivers = [ "nvidia" ];

# Coolbits needed for gwe to underclock
   deviceSection = ''
    Option "Coolbits" "28"
  '';
};

  environment.systemPackages = with pkgs; [
        gwe # Underclock/overclock gpu
        mangohud # Fps viewer
        inputs.nix-citizen.packages.${system}.star-citizen
  ];



  system.stateVersion = "24.05"; # DO NOT CHANGE
}
