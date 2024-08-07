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
