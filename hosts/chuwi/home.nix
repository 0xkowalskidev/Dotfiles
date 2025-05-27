{ ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Fix rotation in hyprland
  wayland.windowManager.hyprland.settings.monitor = [ "DSI-1,preffered,auto,1,transform,3" ];

  # Fix touch screen in hyprland
  wayland.windowManager.hyprland.settings.input.touchdevice ={
    enabled = true;
    transform = "3";
  };
}
