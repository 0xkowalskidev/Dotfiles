{ pkgs, inputs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "kowalski";
  home.homeDirectory = "/home/kowalski";

  # Packages
  home.packages = with pkgs; [
    # Apps
    jellyfin-media-player # Jellyfin client
    spotify
    qbittorrent
    mullvad-browser
    signal-desktop
    discord

    nerd-fonts.fira-code # Font

    # Utils
    ripgrep
    mullvad-vpn
    pamixer # Audio Mixer
    mpv # Video player
    btop
    acpi # Battery viewer
    cloc # Count lines of code
    ncdu # Disk usage analysis
    tt # Typespeed test
    evince # pdf reader
    fastfetch # New neofetch
    cpufetch
    qemu # VMs
    quickemu # VM tools
    inputs.nopswd.packages.x86_64-linux.default # Password manager

    nixfmt # Extra formatter for nix, not included in nil_ls
  ];

  # Alacritty Terminal
  fonts.fontconfig.enable = true;
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.9;
      font = {
        normal = {
          family = "FiraCode Nerd Font Mono";
          style = "regular";
        };
      };
    };
  };

  # Rofi Application Launcher
  programs.rofi = {
    enable = true;
    theme = "material";
  };

  # SSH
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
        HostName github.com
        IdentityFile ~/.ssh/github_rsa
        IdentitiesOnly yes
    '';
  };
  services.ssh-agent.enable = true;

  # Git
  programs.git = {
    enable = true;
    userName = "0xkowalskidev";
    userEmail = "0xkowalskidev@gmail.com";
  };

  # Bash
  programs.bash = { enable = true; };

  # Direnv
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  # Brave Browser
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      # Vimium
      {
        id = "dbepggeogbaibhgnhhndojpepiihcmeb";
      }
      # Video Speed Controller
      {
        id = "nffaoalbilbmmfgbnbgppjihopabppdk";
      }
      # Remove Youtube Shorts
      {
        id = "mgngbgbhliflggkamjnpdmegbkidiapm";
      }
      # Sponsor Block
      {
        id = "mnjggcdmjocbbbhaepdhchncahnbgone";
      }
      # Return Youtube Dislikes
      { id = "gebbhagfogifgggkldgodflihgfeippi"; }
    ];
  };

  # Neovim Editor
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  programs.nixvim = {
    enable = true;
    vimAlias = true;
    viAlias = true;

    opts = {
      number = true; # Show line numbers in the gutter
      tabstop = 2; # Set tab width to 2 spaces
      shiftwidth = 2; # Set indentation width to 2 spaces
      expandtab = true; # Convert tabs to spaces
      autoindent = true; # Automatically indent new lines based on previous line
      wrap = false; # Prevent text from wrapping to the next line
      cursorline = true; # Highlight the line where the cursor is located
      ignorecase = true; # Make searches case-insensitive
      smartcase =
        true; # Override ignorecase if search contains uppercase letters
    };

    # Clipboard 
    clipboard.register = "unnamedplus";
    clipboard.providers.wl-copy.enable = true;

    # Colour Shceme
    colorschemes.catppuccin.enable = true;

    # LSPs
    plugins.lsp = {
      enable = true;
      servers = {
        nil_ls = {
          enable = true;
          settings.formatting.command =
            [ "nixfmt" ]; # Ensure nil_ls uses nixfmt
        };
      };
      keymaps = {
        lspBuf = {
          "gd" = "definition"; # Go to definition
          "K" = "hover"; # Show hover info
          "<leader>ca" = "code_action"; # Code actions
        };
      };
    };

    # Format on save
    plugins.conform-nvim = {
      enable = true;
      autoLoad = true;
      settings = {
        format_on_save = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };
        formatters_by_ft = { nix = [ "nixfmt" ]; };
      };
    };

    # Telescope
    plugins.telescope = {
      enable = true;
      autoLoad = true;

      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
      };
    };

    plugins.web-devicons = {
      enable = true;
      autoLoad = true;
    };

    # Completions
    plugins.cmp = {
      enable = true;
      autoLoad = true;
      autoEnableSources = true;
      settings = {
        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
          "<C-Space>" = "cmp.mapping.complete()";
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "buffer"; }
          { name = "path"; }
          { name = "luasnip"; }
        ];
      };
    };
    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.cmp-path.enable = true;
    plugins.cmp_luasnip.enable = true;
    plugins.luasnip.enable = true;

    # Harpoon
    plugins.harpoon = {
      enable = true;
      autoLoad = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "<A-a>";
        action.__raw = "function() require'harpoon':list():add() end";
      }
      {
        mode = "n";
        key = "<A-h>";
        action.__raw =
          "function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end";
      }
      {
        mode = "n";
        key = "<A-1>";
        action.__raw = "function() require'harpoon':list():select(1) end";
      }
      {
        mode = "n";
        key = "<A-2>";
        action.__raw = "function() require'harpoon':list():select(2) end";
      }
      {
        mode = "n";
        key = "<A-3>";
        action.__raw = "function() require'harpoon':list():select(3) end";
      }
      {
        mode = "n";
        key = "<A-4>";
        action.__raw = "function() require'harpoon':list():select(4) end";
      }
    ];

    # Avante AI 
    plugins.avante = {
      enable = true;
      autoLoad = true;
      settings = {
        provider = "ollama";
        ollama = { model = "qwen2.5-coder:1.5b"; };
      };
    };
  };

  # Window Manager
  ## Waybar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" "custom/right-arrow-dark" ];
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
          "battery"
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
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "MUTE";
          format-icons = {
            headphones = "";
            default = [ "" "" ];
          };
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
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };
        disk = {
          interval = 5;
          format = "Disk {percentage_used}%";
          path = "/";
        };
        tray = { icon-size = 20; };
      };
    };
    style = ''
      * {
        font-size: 20px;
        font-family: monospace;
      }
      window#waybar {
        background: #292b2e;
        color: #fdf6e3;
      }
      #custom-right-arrow-dark,
      #custom-left-arrow-dark {
        color: #1a1a1a;
      }
      #custom-right-arrow-light,
      #custom-left-arrow-light {
        color: #292b2e;
        background: #1a1a1a;
      }
      #workspaces,
      #clock.1,
      #clock.2,
      #clock.3,
      #pulseaudio,
      #memory,
      #cpu,
      #battery,
      #disk,
      #tray {
        background: #1a1a1a;
      }
      #workspaces button {
        padding: 0 2px;
        color: #fdf6e3;
      }
      #workspaces button.active {
        color: #268bd2;
      }
      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        background: #1a1a1a;
        border: #1a1a1a;
        padding: 0 3px;
      }
      #pulseaudio {
        color: #268bd2;
      }
      #memory {
        color: #2aa198;
      }
      #cpu {
        color: #6c71c4;
      }
      #battery {
        color: #859900;
      }
      #disk {
        color: #b58900;
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

  ## Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      exec-once = [ "alacritty" "waybar" ]; # Open terminal on startup

      # General settings
      general = {
        gaps_in = 4;
        gaps_out = 6;
        border_size = 1;
      };

      # Mouse acceleration
      input = { accel_profile = "flat"; };

      # Fast Animations
      animations = {
        enabled = true;
        animation = [
          "windows, 1, 1, default"
          "windowsOut, 1, 1, default"
          "fade, 1, 1, default"
          "workspaces, 1, 1, default"
        ];
      };

      # Keybinds
      bind = [
        "$mod, Return, exec, alacritty" # Open Terminal
        "$mod, Space, exec, rofi -show drun" # Application Launcher
        "$mod, ESCAPE, killactive" # Kill Program

        # Switch Focus
        "$mod, right, movefocus, r" # Focus right
        "$mod, left, movefocus, l" # Focus left
        "$mod, up, movefocus, u" # Focus up
        "$mod, down, movefocus, d" # Focus down

        # Move window
        "$mod SHIFT, right, movewindow, r" # Move window right
        "$mod SHIFT, left, movewindow, l" # Move window left
        "$mod SHIFT, up, movewindow, u" # Move window up
        "$mod SHIFT, down, movewindow, d" # Move window down

        # Resize window
        "$mod ALT, right, resizeactive, -10 0" # Shrink width
        "$mod ALT, left, resizeactive, 10 0" # Grow width
        "$mod ALT, up, resizeactive, 0 -10" # Shrink height
        "$mod ALT, down, resizeactive, 0 10" # Grow height

        # Switch workspace
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

        # Move window to workspace
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
    };
  };

  ## Hyprpaper
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      wallpaper = [ ", ~/background.jpg" ];
      preload = [ "~/background.jpg" ];
    };
  };

  home.stateVersion = "25.05";
}
