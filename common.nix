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

  # Git
  programs.git.enable = true;

  environment.systemPackages = with pkgs;
    [
      lm_sensors # Heat Sensors
    ];
}

