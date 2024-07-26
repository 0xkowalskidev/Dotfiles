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

  # Trackpad
  services.libinput.touchpad.disableWhileTyping = true;



  system.stateVersion = "24.05"; # DO NOT CHANGE
}
