{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "amdgpu.dcdebugmask=0x12" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.firmware = [ pkgs.linux-firmware ];

  # Networking
  networking.hostName = "ace";
  networking.networkmanager.enable = true;
  services.mullvad-vpn.enable = true;
  networking.firewall.allowedTCPPorts = [
    25565
    27015
    28015
    28017
    7777
  ];
  networking.firewall.allowedUDPPorts = [
    25565
    27015
    28015
    28017
    7777
  ];

  # NAS
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/data" = {
    device = "192.168.1.129:/data";
    fsType = "nfs";
    options = [
      "rw"
      "sync"
    ];
  };

  # Second SSD
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/0c83a41b-ebd6-4ad5-ae8f-f6007a671a93";
    fsType = "ext4";
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

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

  # Virtualisation
  virtualisation.containerd.enable = true;
  virtualisation.docker.enable = true;
  users.users.kowalski.extraGroups = [
    "wheel"
    "docker"
  ];

  # Games
  ## Star Citizen
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GB Swap
    }
  ];

  environment.systemPackages = with pkgs; [
    # Star Citizen/Lutris
    wineWowPackages.stable
    winetricks
    libwebp

    lutris

    # Minecraft
    openjdk21
    prismlauncher # Unofficial Minecraft Launcher

    amdgpu_top
    wlr-randr
    mangohud

    rocmPackages_6.rocm-runtime
    rocmPackages_6.rocm-smi
    rocmPackages_6.rocminfo

    # Monero
    monero-gui
  ];
  ## Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # Home Manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };

    users = {
      "kowalski" =
        { ... }:
        {
          imports = [
            ./home.nix
            ../../home.nix
          ];
        };
    };
  };

  system.stateVersion = "25.05";
}
