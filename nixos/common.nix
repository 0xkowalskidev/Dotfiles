{ config, lib, pkgs, inputs, ... }:

{
  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # System
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/London";

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

  # Garbage Collection
  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Graphics
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

  environment.systemPackages = with pkgs; [
        pulsemixer # TUI Audio Mixer
  ];

  #Users
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
		"kowalski" = import ../home-manager/home.nix;
	};
   };
}

