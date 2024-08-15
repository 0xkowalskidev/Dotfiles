{ pkgs, config, lib, ... }:


{
  options =
    {
      alacritty.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Alacritty terminal";
      };
    };


  config = lib.mkIf config.alacritty.enable {
    # Font
    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    fonts.fontconfig.enable = true;

    # Terminal
    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal = {
            family = "FiraCode Nerd Font Mono";
            style = "regular";
          };
          size = 12.0;
        };
      };
    };

  };
}
