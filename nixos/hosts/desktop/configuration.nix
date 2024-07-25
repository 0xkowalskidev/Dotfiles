{ config, ... }:

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

  # GPU

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable multi monitor
  services.xserver = {
  enable = true;
  videoDrivers = [ "nvidia" "intel" ];
   displayManager.sessionCommands = ''
    xrandr --output HDMI2 --primary --mode 1920x1080 --left-of HDMI-1-0 --output HDMI-1-0 --mode 1920x1080
  '';
};



  system.stateVersion = "24.05"; # DO NOT CHANGE
}
