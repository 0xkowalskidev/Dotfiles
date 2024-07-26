{ ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common.nix
    ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Bluetooth 
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Disable Trackpad
  services.xserver.displayManager.sessionCommands = ''
    xinput disable "bcm5974"
  '';



  system.stateVersion = "24.05"; # DO NOT CHANGE
}
