{ config, lib, pkgs, ... }:

{
  options.window-managers.i3.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable I3 and Xserver";
  };

  config = lib.mkIf config.window-managers.i3.enable {
    services.xserver = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        configFile = "/home/kowalski/Dotfiles/i3/config";
      };
    };

    environment.systemPackages = with pkgs; [
      dmenu
    ];
  };
}




