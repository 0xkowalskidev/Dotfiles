{ lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Fix rotation in hyprland
  wayland.windowManager.hyprland.settings.monitor = [ "DSI-1,preferred,auto,1,transform,3" ];

  # Fix touch screen in hyprland
  wayland.windowManager.hyprland.settings.input.touchdevice = {
    enabled = true;
    transform = "3";
  };

  # Battery in waybar (chuwi has a battery, ace doesn't)
  programs.waybar.settings.mainBar = {
    modules-right = lib.mkForce [
      "custom/left-arrow-dark"
      "pulseaudio"
      "custom/left-arrow-light"
      "custom/left-arrow-dark"
      "memory"
      "custom/left-arrow-light"
      "custom/left-arrow-dark"
      "cpu"
      "custom/left-arrow-light"
      "custom/left-arrow-dark"
      "battery"
      "custom/left-arrow-light"
      "custom/left-arrow-dark"
      "disk"
      "custom/left-arrow-light"
      "custom/left-arrow-dark"
      "tray"
    ];
    battery = {
      states = {
        good = 95;
        warning = 30;
        critical = 15;
      };
      format = "{icon} {capacity}%";
      format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
    };
  };
  programs.waybar.style = lib.mkAfter ''
    #battery {
      background: #181825;
      color: #a6e3a1;
      padding: 0 10px;
    }
  '';
}
