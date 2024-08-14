{ config, lib, ... }:


{
  options =
    {
      spotifyPlayer.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable CLI Spotify Player";
      };
    };


  config = lib.mkIf config.spotifyPlayer.enable {
    programs.spotify-player.enable = true;

    # Required by spotify player for notifications, disabling them didnt work 
    # Don't actually want notifications so will just hide them in config
    services.dunst = {
      enable = true;
      settings = {
        global = {
          width = 0;
          height = 0;
          transparency = 100;
          geometry = "0x0";
          padding = 0;
          frame_width = 0;
        };
      };
    };
  };
}
