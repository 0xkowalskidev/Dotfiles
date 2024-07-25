{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
     
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.xserver = {
  	enable = true;
	windowManager.i3 = {
		enable = true;
		configFile = "/home/kowalski/Dotfiles/i3/config";
	};
  };
  
  # Autologin
  services.displayManager = {
  	autoLogin.enable = true;
  	autoLogin.user = "kowalski";
  };

  time.timeZone = "Europe/London";

  # Garbage Collection
  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
        libGL
    ];
  };

  # Audio
  security.rtkit.enable = true;

  services.pipewire = {
  	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = false;
  };

  # Bluetooth 
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

   users.users.kowalski = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     };

   # Ssh
   programs.ssh = {
	startAgent = true;
   };

   # Home Manager
   home-manager = {
   	extraSpecialArgs = { inherit inputs; };
	users = {
		"kowalski" = import ./home.nix;
	};
   };

  system.stateVersion = "24.05"; # DO NOT CHANGE
}

