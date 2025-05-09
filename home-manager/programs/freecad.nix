{ config, lib, pkgs, ... }:

{
  options =
    {
      freecad.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Freecad";
      };
    };

  config = lib.mkIf config.freecad.enable {
    home.packages = with pkgs; [
      freecad
    ];
  };
}
