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
  boot.kernelParams = [
    "amdgpu.cwsr_enable=0" # Workaround for MES hang on Strix Point
    "amdgpu.mes_log_enable=1" # Enable MES logging for GPU crash diagnosis
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
    9898
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
    "kvm"
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

  # Thermal / crash diagnostics
  # 1 Hz trace of CPU/GPU temps, clocks, and power to /var/log/thermal-trace.log.
  # Each line is fsync'd so the state immediately before a hard-freeze survives
  # the power-off. Tail the log with: `tail -n 20 /var/log/thermal-trace.log | jq`.
  systemd.services.thermal-trace = {
    description = "1 Hz thermal/power trace for hard-freeze diagnosis";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    path = [ pkgs.amdgpu_top ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5s";
      Nice = 10;
      ExecStart = "${pkgs.writers.writePython3 "thermal-trace" {
        flakeIgnore = [ "E241" "E302" "E305" "E501" "E701" ];
      } ''
        import json
        import os
        import subprocess
        import time
        from datetime import datetime

        LOG = "/var/log/thermal-trace.log"
        MAX_BYTES = 20 * 1024 * 1024  # rotate at 20 MiB

        def sample():
            try:
                out = subprocess.run(
                    ["amdgpu_top", "--json", "--dump"],
                    capture_output=True, text=True, timeout=5,
                )
                d = json.loads(out.stdout)[0]
            except Exception as e:
                return {"error": str(e)}

            sensors = d.get("Sensors") or {}
            metrics = d.get("gpu_metrics") or {}
            activity = d.get("gpu_activity") or {}

            def sv(key):
                v = sensors.get(key)
                return v.get("value") if isinstance(v, dict) else None

            def t100(key):
                v = metrics.get(key)
                return round(v / 100.0, 1) if v else None

            cores_t = [c / 100.0 for c in (metrics.get("temperature_core") or []) if c]
            cores_w = [w for w in (metrics.get("average_core_power") or []) if w]

            return {
                "cpu_tctl":  sv("CPU Tctl"),
                "edge":      sv("Edge Temperature"),
                "soc_t":     t100("temperature_soc"),
                "gfx_t":     t100("temperature_gfx"),
                "l3_t":      t100("temperature_l3"),
                "core_max":  round(max(cores_t), 1) if cores_t else None,
                "sclk":      sv("GFX_SCLK"),
                "mclk":      sv("GFX_MCLK"),
                "fclk":      sv("FCLK"),
                "socket_w":  sv("Input Power"),
                "gfx_w":     sv("GFX Power"),
                "gfx_busy":  (activity.get("GFX") or {}).get("value"),
                "core_w_mW_sum": sum(cores_w) if cores_w else None,
            }

        def rotate(path):
            try:
                if os.path.getsize(path) > MAX_BYTES:
                    os.replace(path, path + ".1")
            except FileNotFoundError:
                pass

        def main():
            rotate(LOG)
            fd = os.open(LOG, os.O_WRONLY | os.O_CREAT | os.O_APPEND, 0o644)
            try:
                while True:
                    row = {"t": datetime.now().astimezone().isoformat(timespec="seconds"),
                           **sample()}
                    os.write(fd, (json.dumps(row) + "\n").encode())
                    os.fsync(fd)
                    time.sleep(1.0)
                    try:
                        if os.fstat(fd).st_size > MAX_BYTES:
                            os.close(fd)
                            rotate(LOG)
                            fd = os.open(LOG, os.O_WRONLY | os.O_CREAT | os.O_APPEND, 0o644)
                    except Exception:
                        pass
            finally:
                try: os.close(fd)
                except Exception: pass

        if __name__ == "__main__":
            main()
      ''}";
    };
  };

  # TDP cap via ryzenadj — prevents thermal runaway on the F7A's cooling.
  # Observed: stock BIOS lets cores hit 94.4°C (Tjmax=95). These limits
  # pull sustained power back enough to keep core_max under ~85°C.
  # Tune with: sudo ryzenadj --info (read current), then adjust values below.
  systemd.services.ryzenadj-tdp-cap = {
    description = "Apply ryzenadj TDP limits for thermal stability";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit=40000 --fast-limit=50000 --slow-limit=42000 --tctl-temp=85";
    };
  };

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    # Star Citizen
    inputs.nix-citizen.packages.${pkgs.stdenv.hostPlatform.system}.rsi-launcher

    # Minecraft
    openjdk25
    prismlauncher # Unofficial Minecraft Launcher

    ryzenadj # Manual TDP tuning: sudo ryzenadj --info
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

    quickemu
    bubblewrap

    # Gamejanitor CLI
    inputs.gamejanitor.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Extend sudo password cache to 1 hour
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=60
  '';

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
