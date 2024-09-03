{ pkgs, ... }:

{
  imports = [
    ./services
    ./window-managers
    ./games
  ];

  # System
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/London";

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

  # Databases
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "serverhosting" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host    serverhosting  postgres        127.0.0.1/32            md5
      host    serverhosting  postgres        ::1/128                 md5
    '';
  };

  environment.systemPackages = with pkgs; [
    pulsemixer # TUI Audio Mixer
    xclip

    qemu

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

}

