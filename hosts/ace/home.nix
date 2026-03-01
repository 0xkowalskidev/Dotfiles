{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.openclaw.homeManagerModules.openclaw
  ];

  # OpenClaw
  programs.openclaw = {
    enable = true;
    package = pkgs.openclaw;
    config = {
      agents.defaults = {
        workspace = "/home/kowalski/.openclaw/workspace";
        model = {
          primary = "anthropic/claude-sonnet-4-6";
          fallbacks = [ ];
        };
      };

      # Restrict file operations to workspace
      tools.fs.workspaceOnly = true;

      # Disable unused channels
      channels.whatsapp.enabled = false;

      channels.telegram = {
        tokenFile = "/home/kowalski/.openclaw/secrets/telegram-bot-token";
        allowFrom = [ 8681495906 ];
        dmPolicy = "allowlist";
        groupPolicy = "allowlist";
      };

      gateway = {
        mode = "local";
        bind = "loopback"; # only accept local connections
      };

      # Scheduled tasks
      cron.enabled = true;
    };

    # Bundled plugins
    bundledPlugins = {
      summarize.enable = true; # Summarize URLs, PDFs, YouTube
    };
  };

  # Force overwrite openclaw config to avoid backup conflicts
  home.file.".openclaw/openclaw.json".force = true;

  # Load gateway token and restrict filesystem access
  systemd.user.services.openclaw-gateway.Service = {
    EnvironmentFile = "/home/kowalski/.openclaw/secrets/openclaw-gateway-env";
    # Mount empty tmpfs over /home/kowalski, then bind-mount allowed paths
    TemporaryFileSystem = "/home/kowalski:ro";
    BindPaths = [ "/home/kowalski/.openclaw" ];
    BindReadOnlyPaths = [ "/home/kowalski/Dotfiles" ];
    InaccessiblePaths = [ "/root" ];
  };

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-1, 1920x1080@100hz, 0x0, 1"
      "HDMI-A-1, 1920x1080, -1920x0, 1"
    ];
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
    env = [
      "LIBVA_DRIVER_NAME,amdgpu"
      "GBM_BACKEND,amdgpu-drm"
    ];
  };

  # Override .desktop files to prepend mullvad-exclude
  xdg.desktopEntries = {
    steam = {
      name = "Steam";
      exec = "mullvad-exclude steam %U";
      icon = "steam";
      categories = [
        "Network"
        "FileTransfer"
        "Game"
      ];
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
    rsi-launcher = {
      name = "RSI Launcher";
      genericName = "Star Citizen Launcher";
      exec = "mullvad-exclude rsi-launcher %U";
      icon = "rsi-launcher";
      terminal = false;
      categories = [ "Game" ];
      mimeType = [ "application/x-rsi-launcher" ];
    };
    "org.prismlauncher.PrismLauncher" = {
      name = "PrismLauncher";
      exec = "mullvad-exclude prismlauncher %U";
      icon = "prismlauncher";
      categories = [ "Game" ];
      genericName = "Minecraft Launcher";
      comment = "A custom launcher for Minecraft";
    };
    discord = {
      name = "Discord";
      exec = "mullvad-exclude discord %U";
      icon = "discord";
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      genericName = "Discord";
      comment = "Voice, Video and Text Chat";
    };
  };
}
