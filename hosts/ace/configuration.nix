{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  masscan-wrapped = pkgs.symlinkJoin {
    name = "masscan-wrapped";
    paths = [ pkgs.masscan ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/masscan \
        --prefix LD_LIBRARY_PATH : "${pkgs.libpcap.lib}/lib"
    '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "amdgpu.cwsr_enable=0" # Workaround for MES hang on Strix Point
    "mitigations=off" # Disable CPU security mitigations for performance
  ];
  boot.kernelPackages = pkgs.linuxPackages_cachyos; # CachyOS kernel for gaming
  hardware.firmware = [ pkgs.linux-firmware ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  fonts.packages = [ pkgs.noto-fonts-cjk-sans ];

  # Networking
  networking.hostName = "ace";
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false; # Faster boot
  services.mullvad-vpn.enable = true;
  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Prevent suspend so SSH stays reachable
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  networking.firewall.allowedTCPPorts = [
    22
    25565
    27015
    28015
    28017
    7777
    8080
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
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
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
        user = "warsmite";
      };
      default_session = initial_session;
    };
  };

  # Virtualisation
  virtualisation.containerd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;
  users.users.warsmite.extraGroups = [
    "wheel"
    "docker"
    "podman"
  ];

  # Postgres
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = [ "gamejanitor" ];
    ensureUsers = [
      { name = "warsmite"; }
    ];
    initialScript = pkgs.writeText "pg-init" ''
      ALTER DATABASE gamejanitor OWNER TO warsmite;
    '';
  };

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
    "vm.swappiness" = 10; # Prefer RAM over swap
    "vm.vfs_cache_pressure" = 50; # Keep file cache longer
  };

  # zram (compressed RAM swap - faster than disk)
  zramSwap = {
    enable = true;
    memoryPercent = 50; # Use up to 50% of RAM for zram
    algorithm = "zstd";
  };

  # I/O scheduler for NVMe
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="kyber"
  '';

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
    whisper-cpp-vulkan

    # Monero
    monero-gui

    masscan-wrapped

    quickemu
  ];

  # Grant masscan raw socket access without sudo
  security.wrappers.masscan = {
    source = "${masscan-wrapped}/bin/masscan";
    capabilities = "cap_net_raw+ep";
    owner = "root";
    group = "root";
  };

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
      "warsmite" =
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
