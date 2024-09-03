{ config, inputs, ... }:

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
  games.star-citizen.enable = true;
  games.r2modman.enable = true;

  # Projects
  projects.container-orchestrator.enable = true;

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
    description = "Set NVIDIA GPU Power Limit to 160W";
    after = [ "nvidia-persistenced.service" "display-manager.service" ]; # Run after NVIDIA persistence daemon and X server start
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/nvidia-smi -pl 160";
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
