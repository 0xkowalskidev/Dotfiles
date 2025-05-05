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
        ExecStartPre = [
          "${pkgs.coreutils}/bin/chown -R rust-gameserver:rust-gameserver /var/lib/rust-gameserver"
          "${pkgs.coreutils}/bin/chmod -R u+rwX /var/lib/rust-gameserver"
        ];
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
        ${pkgs.steam-run}/bin/steam-run /var/lib/rust-gameserver/RustDedicated \
          +server.port 28015 \
          +server.level "Procedural Map" \
          +server.seed 1234 \
          +server.worldsize 1000 \
          +server.maxplayers 10 \
          +server.hostname "test" \
          +server.description "test!" \
          +server.identity "server1" \ 
          +rcon.port 28016 \
          +rcon.password letmein \ 
          +rcon.web 1 \ 
          -logfile server.log 
      '';

    };
  };
}

