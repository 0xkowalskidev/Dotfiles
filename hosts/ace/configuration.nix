{ inputs, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ../../common.nix ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "amdgpu.dcdebugmask=0x12" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "ace";
  networking.networkmanager.enable = true;
  services.mullvad-vpn.enable = true;
  networking.firewall.allowedTCPPorts = [ 25565 27015 28015 28017 7777 ];
  networking.firewall.allowedUDPPorts = [ 25565 27015 28015 28017 7777 ];

  # NAS
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/data" = {
    device = "192.168.1.129:/data";
    fsType = "nfs";
    options = [ "rw" "sync" ];
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

  # LLama cpp
  hardware.amdgpu.opencl.enable = true;

  ## servies.llama-cpp would not compile with rocm even when forced to with package
  #systemd.services.llama-cpp = {
  #  description = "Custom Llama.cpp Server";
  #  after = [ "network.target" ];
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig = {
  #    ExecStart = ''
  #      ${pkgs.llama-cpp.override { rocmSupport = true; }}/bin/llama-server \
  #        --model /home/kowalski/models/gemma-3-4b-it-q4_0.gguf \
  #         --n-gpu-layers 99
  #     '';
  #     User = "kowalski";
  #     Group = "users";
  #     Restart = "always";
  #    Environment = [ "HSA_OVERRIDE_GFX_VERSION=11.0.0" ];
  #  };
  #  };

  # Virtualisation
  virtualisation.containerd.enable = true;
  virtualisation.docker.enable = true;
  users.users.kowalski.extraGroups = [ "wheel" "docker" ];

  # Games
  ## Star Citizen
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024; # 16 GB Swap
  }];
  zramSwap = {
    enable = true;
    memoryMax = 16 * 1024 * 1024 * 1024; # 16 GB ZRAM
  };

  nix.settings = {
    substituters = [ "https://nix-citizen.cachix.org" ];
    trusted-public-keys = [
      "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
    ];
  };

  environment.systemPackages = with pkgs; [
    # Star Citizen
    inputs.nix-citizen.packages.${system}.star-citizen

    # Minecraft     
    openjdk21
    prismlauncher # Unofficial Minecraft Launcher

    amdgpu_top
    wlr-randr
    mangohud

    rocmPackages_6.rocm-runtime
    rocmPackages_6.rocm-smi
    rocmPackages_6.rocminfo
    (pkgs.llama-cpp.override { rocmSupport = true; })
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
      "kowalski" = { ... }: { imports = [ ./home.nix ../../home.nix ]; };
    };
  };

  system.stateVersion = "25.05";
}
