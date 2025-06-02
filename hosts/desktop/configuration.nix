{ inputs, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ../../common.nix ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;
  services.mullvad-vpn.enable = true;

  # Power
  powerManagement.cpuFreqGovernor = "performance";

  # NAS
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/data" = {
    device = "192.168.1.129:/data";
    fsType = "nfs";
    options = [ "rw" "sync" ];
  };

  # Drives
  fileSystems = {
    "/mnt/secondary" = {
      device = "/dev/disk/by-uuid/4309d554-ce7d-4225-be36-9f7618418310";
      fsType = "ext4";
    };

    "/mnt/tertiary" = {
      device = "/dev/disk/by-uuid/89f9e5df-e79e-4695-a9f3-f67a8bb49cf4";
      fsType = "ext4";
    };
  };

  # Nvidia + Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaPersistenced = true;
    powerManagement.enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Autologin
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "hyprland";
        user = "kowalski";
      };
      default_session = initial_session;
    };
  };

  # Games
  ## Lutris/Star Citizen
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  swapDevices = [{
    device = "/mnt/secondary/swapfile";
    size = 16 * 1024; # 16 GB Swap
  }];

  zramSwap = {
    enable = true;
    memoryMax = 16 * 1024 * 1024 * 1024; # 16 GB ZRAM
  };

  environment.systemPackages = with pkgs; [
    # Lutris
    wineWowPackages.stable
    winetricks
    libwebp
    lutris
    # Minecraft     
    openjdk21
    prismlauncher # Unofficial Minecraft Launcher
  ];
  ## Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # Gpu or Psu is broken, lower power limit
  systemd.services.setGpuPowerLimit = {
    description = "Set NVIDIA GPU Power Limit to 125W";
    after = [
      "nvidia-persistenced.service"
      "display-manager.service"
    ]; # Run after NVIDIA persistence daemon and X server start
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/nvidia-smi -pl 125";
    };
  };

  # Home Manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };

    users = {
      "kowalski" = { ... }: { imports = [ ./home.nix ../../home.nix ]; };
    };
  };

  system.stateVersion = "25.05";
}
