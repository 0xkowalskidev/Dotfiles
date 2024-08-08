{ config, pkgs, ... }:

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

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    nvidiaPersistenced = true;

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

   # Coolbits needed for gwe to underclock
   deviceSection = ''
    Option "Coolbits" "28"
  '';
};

  environment.systemPackages = with pkgs; [
        gwe # Underclock/overclock gpu
  ];



  system.stateVersion = "24.05"; # DO NOT CHANGE
}
