{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "grumpy";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  # Gameservers
  virtualisation.docker.enable = true;

  networking.firewall = {
    allowedTCPPorts = [
      3000 # Web UI
      25565 # Minecraft
      7777 # Terraria
      27015 # Garry's Mod / Source games
      28016 # Rust RCON
    ];
    allowedUDPPorts = [
      2456
      2457
      2458 # Valheim
      8211 # Palworld
      27015 # Garry's Mod / Palworld query
      28015 # Rust
    ];
    allowedTCPPortRanges = [
      {
        from = 49152;
        to = 65535;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 49152;
        to = 65535;
      }
    ];
  };

  # Create systemd service
  systemd.services.gameservers = {
    description = "Gameserver Management Panel";
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "docker.service"
    ];
    requires = [ "docker.service" ];

    environment = {
      DEBUG = "";
      GAMESERVER_HOST = "0.0.0.0";
      GAMESERVER_PORT = "3000";
      GAMESERVER_SHUTDOWN_TIMEOUT = "30s";
      GAMESERVER_DATABASE_PATH = "/var/lib/gameservers/gameservers.db";
      GAMESERVER_DOCKER_SOCKET = ""; # Uses default: /var/run/docker.sock
      GAMESERVER_CONTAINER_NAMESPACE = "gameservers";
      GAMESERVER_CONTAINER_STOP_TIMEOUT = "30s";
      GAMESERVER_MAX_FILE_EDIT_SIZE = "10485760";
      GAMESERVER_MAX_UPLOAD_SIZE = "104857600";

    };

    serviceConfig = {
      ExecStart = "${inputs.gameservers.packages.${pkgs.system}.default}/bin/gameservers";
      StateDirectory = "gameservers";
      WorkingDirectory = "/var/lib/gameservers";
      Restart = "on-failure";
      DynamicUser = true;
      SupplementaryGroups = [ "docker" ];
    };
  };

  # User
  users.users.kowalski = {
    isNormalUser = true;
    home = "/home/kowalski";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
