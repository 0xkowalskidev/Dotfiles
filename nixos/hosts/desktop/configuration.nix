{ config, inputs, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common.nix
    ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  # Networking
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  # Window Manager
  window-managers.i3.enable = true;

  # Games
  games.minecraft.enable = true;
  games.steam.enable = true;
  games.r2modman.enable = true;
  games.lutris.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
  services.open-webui.enable = true;
  services.open-webui.openFirewall = true;
  services.open-webui.host = "0.0.0.0";

  # NAS
  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/mnt/data" = {
    device = "192.168.1.129:/data";
    fsType = "nfs";
    options = [ "rw" "sync" ];
  };

  nixpkgs.overlays = [
    (self: super: {
      jellyfin-ffmpeg = super.jellyfin-ffmpeg.override {
        ffmpeg_7-full = super.ffmpeg_7-full.override {
          withNvenc = true;
          withUnfree = true;
        };
      };
    })
  ];
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = true;

  # Projects
  projects.container-orchestrator.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [ 22 25565 ];

    allowedTCPPortRanges = [
      { from = 30000; to = 32767; }
    ];


    allowedUDPPortRanges = [
      { from = 30000; to = 32767; }
    ];
  };

  networking.nameservers = [ "1.1.1.1 8.8.8.8" ];

  # Autologin
  services.displayManager = {
    autoLogin.enable = true;
    autoLogin.user = "kowalski";
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


  # GPU
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaPersistenced = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    # Disable unwanted mouse settings
    displayManager.sessionCommands = ''
      mouse_id=$(xinput list --id-only "pointer:Razer Razer DeathAdder Essential")
      if [ -n "$mouse_id" ]; then
        # Disable middle mouse button emulation
        xinput set-prop "$mouse_id" "libinput Middle Emulation Enabled" 0

        # Set acceleration profile
        xinput set-prop "$mouse_id" "libinput Accel Profile Enabled" 0 0 0
      fi
    '';
  };

  # Gpu or Psu is broken, lower power limit
  systemd.services.setGpuPowerLimit = {
    description = "Set NVIDIA GPU Power Limit to 125W";
    after = [ "nvidia-persistenced.service" "display-manager.service" ]; # Run after NVIDIA persistence daemon and X server start
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
      "kowalski" = { ... }: {
        imports = [
          ./home.nix
          inputs.self.outputs.homeManagerModules.default
        ];
      };
    };
  };



  system.stateVersion = "24.05"; # DO NOT CHANGE
}
