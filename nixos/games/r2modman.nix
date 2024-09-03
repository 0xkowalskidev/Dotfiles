{ config, lib, pkgs, ... }:

{
  options.games.r2modman.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the r2modmanager for Lethal Company and others";
  };

  config = lib.mkIf config.games.r2modman.enable {
    environment.systemPackages = with pkgs; [
      r2modman
    ];
  };
}




