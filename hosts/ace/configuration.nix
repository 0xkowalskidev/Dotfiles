{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelParams = [ "amdgpu.dcdebugmask=0x12" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.firmware = [ pkgs.linux-firmware ];
  boot.initrd.kernelModules = [ "amdgpu" ];

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

  # Second SSD
  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/0c83a41b-ebd6-4ad5-ae8f-f6007a671a93";
    fsType = "ext4";
    options = [ "nofail" "x-systemd.device-timeout=5s" ];
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

  # Ollama (Vulkan works better on Strix Point gfx1150)
  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama-vulkan;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "32768";
    };
  };
  #services.open-webui.enable = true;

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

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    # Star Citizen
    inputs.nix-citizen.packages.${pkgs.stdenv.hostPlatform.system}.rsi-launcher

    # Minecraft
    openjdk21
    prismlauncher # Unofficial Minecraft Launcher

    amdgpu_top
    wlr-randr
    mangohud
    lsof

    rocmPackages_6.rocm-runtime
    rocmPackages_6.rocm-smi
    rocmPackages_6.rocminfo
    pkgs-unstable.ollama

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
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
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
