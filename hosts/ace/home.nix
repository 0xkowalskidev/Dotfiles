{ ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Monitors
  wayland.windowManager.hyprland.settings = {
    monitor =
      [ "DP-1, 1920x1080@100hz, 0x0, 1" "HDMI-A-1, 1920x1080, -1920x0, 1" ];
    workspace = [
      "1, monitor:DP-1, default:true"
      "2, monitor:DP-1"
      "3, monitor:DP-1"
      "4, monitor:DP-1"
      "5, monitor:DP-1"
      "6, monitor:DP-1"
      "7, monitor:DP-1"
      "8, monitor:DP-1"
      "9, monitor:DP-1"
      "10, monitor:HDMI-A-1"
    ];

    env = [ "LIBVA_DRIVER_NAME,amdgpu" "GBM_BACKEND,amdgpu-drm" ];
  };

  # Override .desktop files to prepend mullvad-exclude
  xdg.desktopEntries = {
    steam = {
      name = "Steam";
      exec = "mullvad-exclude steam %U";
      icon = "steam";
      categories = [ "Network" "FileTransfer" "Game" ];
      genericName = "Steam";
      comment = "Application for managing and playing games on Steam";
    };
    lutris = {
      name = "Lutris";
      exec = "mullvad-exclude lutris %U";
      icon = "lutris";
      categories = [ "Game" ];
      genericName = "Lutris";
      comment = "Open gaming platform";
    };
    "org.prismlauncher.PrismLauncher" = {
      name = "PrismLauncher";
      exec = "mullvad-exclude prismlauncher %U";
      icon = "prismlauncher";
      categories = [ "Game" ];
      genericName = "Minecraft Launcher";
      comment = "A custom launcher for Minecraft";
    };
    star-citizen = {
      name = "Star Citizen";
      comment = "Star Citizen - Alpha";
      exec = "mullvad-exclude star-citizen %U";
      icon = "star-citizen";
      categories = [ "Game" ];
      mimeType = [ "application/x-star-citizen-launcher" ];
      type = "Application";
      settings = { Version = "1.4"; };
    };
  };
}
