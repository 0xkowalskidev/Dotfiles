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
    18080
  ];
  networking.firewall.allowedUDPPorts = [
    25565
    27015
    28015
    28017
    7777
    18080
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

  # Ollama
  hardware.amdgpu.opencl.enable = true;

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1150";
    };
    rocmOverrideGfx = "11.0.0";
    openFirewall = true;
    host = "0.0.0.0";
    port = 11111;
  };

  # Monero
  services.monero = {
    enable = true;
    dataDir = "/data/monero";
    environmentFile = "/etc/monero/monero.env";
    rpc = {
      address = "127.0.0.1";
      port = 18081;
    };
    extraConfig = ''
      zmq-pub=tcp://127.0.0.1:18083
    '';
    prune = true;
  };

  users.users.monero = {
    isSystemUser = true;
    group = "monero";
  };
  users.groups.monero = { };

  systemd.services.p2pool = {
    description = "P2Pool Monero mining pool";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "monero.service"
    ];
    serviceConfig = {
      EnvironmentFile = "/etc/monero/monero.env";
      ExecStart = ''
        ${pkgs.p2pool}/bin/p2pool \
          --host 127.0.0.1 \
          --rpc-port 18081 \
          --wallet $MONERO_WALLET \
          --mini \
          --data-dir /data/p2pool \
      '';
      Restart = "always";
      User = "monero";
      Group = "monero";
    };
  };

  services.xmrig = {
    enable = true;
    settings = {
      autosave = true;
      cpu = {
        enabled = true;
        huge-pages = true;
        huge-pages-jit = true;
        priority = 2;
        max-threads-hint = 80; # ~9-10 threads for 12-core CPU
        asm = true;
        randomx = {
          "1gb-pages" = true;
          mode = "fast";
          numa = true;
        };
      };
      opencl = false; # No GPU mining for RandomX
      cuda = false;
      pools = [
        {
          url = "127.0.0.1:3333";
          user = "$(cat /etc/monero/monero.env | grep MONERO_WALLET | cut -d= -f2)";
          keepalive = true;
          tls = false;
        }
      ];
    };
  };

  # Ensure p2pool starts before XMRig
  systemd.services.xmrig.after = [ "p2pool.service" ];

  # Enable huge pages for RandomX
  boot.kernel.sysctl = {
    "vm.nr_hugepages" = 1280; # ~2.5 GB for 9-10 threads
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
  zramSwap = {
    enable = true;
    memoryMax = 16 * 1024 * 1024 * 1024; # 16 GB ZRAM
  };

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
    p2pool
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
