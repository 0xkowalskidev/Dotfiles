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

  # Virtualisation
  virtualisation.docker.enable = true;
  virtualisation.containerd.enable = true;

  # For container orchestrator project
  # Etcd
  services.etcd.enable = true;

  # CNI
  environment.etc."cni/net.d/10-mynet.conflist".text = ''
 {
  "cniVersion": "1.0.0",
  "name": "mynet",
  "plugins": [
    {
      "type": "bridge",
      "bridge": "cni0",
      "isGateway": true,
      "ipMasq": true,
      "ipam": {
        "type": "host-local",
        "subnet": "10.22.0.0/16",
        "routes": [
          { "dst": "0.0.0.0/0" }
        ]
      }
    },
    {
      "type": "portmap",
      "capabilities": {
        "portMappings": true
      },
      "snat": true
    }
  ]
}
  '';

  environment.systemPackages = with pkgs; [
        pulsemixer # TUI Audio Mixer
	dmenu
	xclip
        
        # For container orchestrator project
        cni
        cni-plugins
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

