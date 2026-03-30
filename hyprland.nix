{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.hyprland.enable = lib.mkEnableOption "Hyprland desktop environment";

  config = lib.mkIf config.my.hyprland.enable {
    # Hyprland packages
    home.packages = with pkgs; [
      hyprlock
      hyprshot
      libnotify
      wl-clipboard
    ];

    # Wofi Application Launcher
    programs.wofi = {
      enable = true;
      settings = {
        show = "drun";
        term = "alacritty";
        allow_images = true;
        allow_markup = true;
        width = 600;
        height = 400;
        location = "center";
        orientation = "vertical";
        halign = "fill";
        insensitive = true;
        prompt = "Search...";
        filter_rate = 100;
        no_actions = true;
        matching = "contains";
        cache_file = "/dev/null";
      };

      style = ''
        * {
          font-family: "FiraCode Nerd Font Mono";
          font-size: 14px;
        }

        window {
          margin: 0px;
          border: 1px solid #45475a;
          background-color: #1e1e2e;
        }

        #input {
          margin: 8px;
          padding: 8px 12px;
          border: none;
          background-color: #313244;
          color: #cdd6f4;
        }

        #inner-box {
          margin: 4px 8px;
        }

        #outer-box {
          margin: 0px;
        }

        #scroll {
          margin: 0px;
        }

        #text {
          margin: 4px;
          color: #cdd6f4;
        }

        #entry {
          padding: 6px 8px;
        }

        #entry:selected {
          background-color: #313244;
        }

        #text:selected {
          color: #89b4fa;
        }
      '';
    };

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          modules-left = [
            "hyprland/workspaces"
            "custom/right-arrow-dark"
          ];
          modules-center = [
            "custom/left-arrow-dark"
            "clock#1"
            "custom/left-arrow-light"
            "custom/left-arrow-dark"
            "clock#2"
            "custom/right-arrow-dark"
            "custom/right-arrow-light"
            "clock#3"
            "custom/right-arrow-dark"
          ];
          modules-right = [
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
            "disk"
            "custom/left-arrow-light"
            "custom/left-arrow-dark"
            "tray"
          ];
          "custom/left-arrow-dark" = {
            format = "";
            tooltip = false;
          };
          "custom/left-arrow-light" = {
            format = "";
            tooltip = false;
          };
          "custom/right-arrow-dark" = {
            format = "";
            tooltip = false;
          };
          "custom/right-arrow-light" = {
            format = "";
            tooltip = false;
          };
          "hyprland/workspaces" = {
            disable-scroll = true;
            format = "{name}";
          };
          "clock#1" = {
            format = "{:%a}";
            tooltip = false;
          };
          "clock#2" = {
            format = "{:%H:%M}";
            tooltip = false;
          };
          "clock#3" = {
            format = "{:%m-%d}";
            tooltip = false;
          };
          pulseaudio = {
            format = "{volume}%";
            format-muted = "MUTE";
            scroll-step = 5;
            on-click = "pamixer -t";
          };
          memory = {
            interval = 5;
            format = "Mem {}%";
          };
          cpu = {
            interval = 5;
            format = "CPU {usage}%";
          };
          disk = {
            interval = 5;
            format = "Disk {percentage_used}%";
            path = "/";
          };
          tray = {
            icon-size = 20;
          };
        };
      };
      style = ''
        * {
          font-size: 18px;
          font-family: "FiraCode Nerd Font Mono";
        }
        window#waybar {
          background: #1e1e2e;
          color: #cdd6f4;
        }
        #custom-right-arrow-dark,
        #custom-left-arrow-dark {
          color: #181825;
        }
        #custom-right-arrow-light,
        #custom-left-arrow-light {
          color: #1e1e2e;
          background: #181825;
        }
        #workspaces,
        #clock.1,
        #clock.2,
        #clock.3,
        #pulseaudio,
        #memory,
        #cpu,
        #disk,
        #tray {
          background: #181825;
        }
        #workspaces button {
          padding: 0 2px;
          color: #cdd6f4;
        }
        #workspaces button.active {
          color: #89b4fa;
        }
        #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
          background: #181825;
          border: #181825;
          padding: 0 3px;
        }
        #pulseaudio {
          color: #89b4fa;
        }
        #memory {
          color: #94e2d5;
        }
        #cpu {
          color: #cba6f7;
        }
        #disk {
          color: #f9e2af;
        }
        #clock,
        #pulseaudio,
        #memory,
        #cpu,
        #battery,
        #disk {
          padding: 0 10px;
        }
      '';
    };

    # Hyprland
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        exec-once = [
          "hyprctl dispatch exec '[workspace 1] alacritty'"
          "waybar"
        ];

        general = {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 0;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          initial_workspace_tracking = 2;
          vfr = true;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        decoration = {
          rounding = 0;
          blur.enabled = false;
          shadow.enabled = false;
        };

        input = {
          accel_profile = "flat";
        };

        animations = {
          enabled = true;
          animation = [
            "windows, 1, 1, default"
            "windowsOut, 1, 1, default"
            "fade, 1, 1, default"
            "workspaces, 1, 1, default"
          ];
        };

        bind = [
          "$mod, Return, exec, alacritty"
          "$mod, b, exec, brave"
          "$mod, Space, exec, wofi --show drun"
          "$mod, ESCAPE, killactive"
          "$mod, f, fullscreen"
          "$mod, L, exec, hyprlock"
          ", Print, exec, hyprshot -m output -o ~/screenshots"
          "SHIFT, Print, exec, hyprshot -m region -o ~/screenshots"
          "CTRL, Print, exec, hyprshot -m window -o ~/screenshots"
          "$mod, right, movefocus, r"
          "$mod, left, movefocus, l"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
          "$mod ALT, left, resizeactive, -10 0"
          "$mod ALT, right, resizeactive, 10 0"
          "$mod ALT, up, resizeactive, 0 -10"
          "$mod ALT, down, resizeactive, 0 10"
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"
        ];

        windowrulev2 = [
          "tile,class:^(steam)$,title:^(Steam)$"
          "tile,class:^(Steam)$,title:^(Steam)$"
          "float,class:^(steam)$,title:^(Steam Settings)$"
          "float,class:^(steam)$,title:^()$"
          "float,class:^(Steam)$,title:^()$"
          "workspace 4 silent,class:^(steam_app_.*)$"
          "workspace 4 silent,class:^(rsi launcher\.exe)$"
          "workspace 4 silent,class:^(starcitizen\.exe)$"
        ];
      };
    };

    # Hyprpaper
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        wallpaper = [ ", ~/dotfiles/images/background.jpg" ];
        preload = [ "~/dotfiles/images/background.jpg" ];
      };
    };

    # Hyprlock
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          grace = 3;
        };
        background = {
          path = "~/dotfiles/images/background.jpg";
          blur_passes = 2;
          blur_size = 4;
        };
        label = [
          {
            text = "$TIME";
            font_size = 72;
            font_family = "FiraCode Nerd Font Mono";
            color = "rgb(cdd6f4)";
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
          {
            text = "cmd[update:3600000] date '+%A, %B %d'";
            font_size = 20;
            font_family = "FiraCode Nerd Font Mono";
            color = "rgb(a6adc8)";
            position = "0, 120";
            halign = "center";
            valign = "center";
          }
          {
            text = "warsmite";
            font_size = 16;
            font_family = "FiraCode Nerd Font Mono";
            color = "rgb(89b4fa)";
            position = "0, 50";
            halign = "center";
            valign = "center";
          }
        ];
        input-field = {
          size = "150, 30";
          outline_thickness = 0;
          outer_color = "rgba(00000000)";
          inner_color = "rgba(00000000)";
          font_color = "rgb(cdd6f4)";
          fade_on_empty = true;
          placeholder_text = "";
          check_color = "rgba(00000000)";
          fail_color = "rgba(00000000)";
          fail_text = "Wrong Password";
          position = "0, -20";
          halign = "center";
          valign = "center";
        };
      };
    };

    # Mako (notifications)
    services.mako = {
      enable = true;
      settings = {
        font = "FiraCode Nerd Font Mono 11";
        background-color = "#1e1e2e";
        text-color = "#cdd6f4";
        border-color = "#313244";
        border-radius = 0;
        border-size = 1;
        padding = "10";
        margin = "10";
        default-timeout = 5000;
      };
    };

    # Hypridle
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    # XDG Portal
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common.default = [
        "gtk"
        "hyprland"
      ];
    };
  };
}
