{ config, lib, pkgs, ... }:

{
  options.games.steam.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable steam.";
  };

  config = lib.mkIf config.games.steam.enable {
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;
    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud # Fps viewer
    ];
  };
}




