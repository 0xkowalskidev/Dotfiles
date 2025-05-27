{ pkgs, inputs, ... }:

{
  programs.home-manager.enable = true;

  home.username = "kowalski";
  home.homeDirectory = "/home/kowalski";

  # Packages
  home.packages = with pkgs; [
    # Apps
    jellyfin-media-player #Jellyfin client
    spotify
    qbittorrent
    mullvad-browser
    signal-desktop
    zapzap # Whatsapp
    discord
    alacritty

    # Utils
    mullvad-vpn
    pulsemixer # TUI Audio Mixer
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
  ];

  # Rofi Application Launcher
  programs.rofi = { 
    enable = true;
  };

  # Git
  programs.git = {
    enable = true;
    userName = "0xkowalskidev";
    userEmail = "0xkowalskidev@gmail.com";
  };
  
  # Bash
  programs.bash ={
    enable = true;
  };

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
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
        # Video Speed Controller
        { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; }
        # Remove Youtube Shorts
        { id = "mgngbgbhliflggkamjnpdmegbkidiapm"; }
        # Sponsor Block
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
        # Return Youtube Dislikes
        { id = "gebbhagfogifgggkldgodflihgfeippi"; }
    ];
  };

  # Neovim Editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Hyprland Window Manager
  wayland.windowManager.hyprland = {
   enable = true;
   settings= 
   {   
      "$mod" = "SUPER";
      "exec-once" = "alacritty"; # Open terminal on startup
      bind = [
        "$mod, Return, exec, alacritty" # Open Terminal
	"$mod, Space, exec, rofi -show drun" # Application Launcher
	"$mod, ESCAPE, killactive" # Kill Program
        
	# Switch Focus
        "$mod, right, movefocus, r" # Focus right
        "$mod, left, movefocus, l"  # Focus left
        "$mod, up, movefocus, u"    # Focus up
        "$mod, down, movefocus, d"  # Focus down

        # Move window
        "$mod SHIFT, right, movewindow, r" # Move window right
        "$mod SHIFT, left, movewindow, l"  # Move window left
        "$mod SHIFT, up, movewindow, u"    # Move window up
        "$mod SHIFT, down, movewindow, d"  # Move window down

        # Resize window
        "$mod ALT, right, resizeactive, -10 0" # Shrink width
        "$mod ALT, left, resizeactive, 10 0"   # Grow width
        "$mod ALT, up, resizeactive, 0 -10"    # Shrink height
        "$mod ALT, down, resizeactive, 0 10"   # Grow height

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

  home.stateVersion = "25.05"; 
}
