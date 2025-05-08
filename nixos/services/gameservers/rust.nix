{ lib, config, pkgs, ... }:

{
  options.services.gameservers.rust = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Rust gameserver.";
      default = false;
    };
  };

  config = lib.mkIf config.services.gameservers.rust.enable {
    users.users.rust-gameserver = {
      isSystemUser = true;
      group = "rust-gameserver";
      home = "/var/lib/rust-gameserver";
      createHome = true;
    };

    users.groups.rust-gameserver = { };

    environment.systemPackages = with pkgs; [ steamcmd steam-run ];

    networking.firewall.allowedUDPPorts = [ 28015 28082 ];
    networking.firewall.allowedTCPPorts = [ 28016 ];

    systemd.services.rust-gameserver = {
      description = "Rust Gameserver";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "rust-gameserver";
        Group = "rust-gameserver";
        WorkingDirectory = "/var/lib/rust-gameserver";
        Restart = "no";
        TimeoutStartSec = "10m";
      };

      preStart = ''
        ${pkgs.steamcmd}/bin/steamcmd \
          +force_install_dir /var/lib/rust-gameserver \
          +login anonymous \
          +app_update 258550 \
          validate \
          +quit
      '';

      script = ''
        ${pkgs.steam-run}/bin/steam-run /var/lib/rust-gameserver/RustDedicated -batchmode -logfile server.log
      '';

    };
  };
}

