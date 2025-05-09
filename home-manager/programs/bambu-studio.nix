{ config, lib, pkgs, ... }:

{
  options =
    {
      bambu-studio.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Bambu Studio";
      };
    };

  config = lib.mkIf config.bambu-studio.enable {
    home.packages = with pkgs; [
      bambu-studio
    ];
  };
}
