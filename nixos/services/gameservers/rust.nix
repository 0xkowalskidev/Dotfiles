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
        Restart = "on-failure";
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
        ${pkgs.steam-run}/bin/steam-run ./RustDedicated \
          -noeac \ 
          +server.port 28015 \
          +rcon.port 28016 \
          +server.maxplayers 50 \
          +server.hostname "My NixOS Rust Server" \
          +server.identity "rust_server" \
          +server.level "Procedural Map" \
          +server.seed 12345 \
          +server.worldsize 4000 \
          -logfile "rust_server.log"
      '';

    };
  };
}

