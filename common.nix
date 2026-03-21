{
  pkgs,
  lib,
  config,
  ...
}:

{
  # System
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "warsmite" ];

  time.timeZone = "Europe/London";

  # NAS
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems = lib.mkIf (config.networking.hostName != "doc") {
    "/mnt/data" = {
      device = "192.168.1.129:/data";
      fsType = "nfs";
      options = [
        "rw"
        "sync"
        "x-systemd.automount"
        "x-systemd.mount-timeout=30"
        "retry=3"
      ];
    };
  };

  #Users
  users.users.warsmite = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Ssh
  programs.ssh = {
    startAgent = true;
  };

  programs.nix-ld.enable = true;

  # Homelab
  networking.extraHosts = ''
    192.168.1.17 ace
    192.168.1.69 dopey
    192.168.1.102 sleepy
    192.168.1.129 doc
    192.168.1.184 grumpy
    51.68.38.150 bashful
  '';

  # Git
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors # Heat Sensors
  ];
}
