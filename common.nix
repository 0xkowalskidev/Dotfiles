{ pkgs, ... }:

{
  # System
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/London";

  #Users
  users.users.kowalski = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Ssh
  programs.ssh = { startAgent = true; };

  # Homelab
  networking.extraHosts = ''
    192.168.1.69 dopey
    192.168.1.102 sleepy
    192.168.1.129 doc
    192.168.1.184 grumpy
  '';

  # Git
  programs.git.enable = true;

  environment.systemPackages = with pkgs;
    [
      lm_sensors # Heat Sensors
    ];
}

