{ lib, config, pkgs, ... }:

{
  options.services.gameservers.satisfactory = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Satisfactory gameserver.";
      default = false;
    };
  };

  config = lib.mkIf config.services.gameservers.satisfactory.enable {
    users.users.satisfactory-gameserver = {
      isSystemUser = true;
      group = "satisfactory-gameserver";
      home = "/var/lib/satisfactory-gameserver";
      createHome = true;
    };

    users.groups.satisfactory-gameserver = { };

    networking.firewall.allowedUDPPorts = [ 7777 15000 15777 ];

    systemd.services.satisfactory-gameserver = {
      description = "Satisfactory Gameserver";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "satisfactory-gameserver";
        Group = "satisfactory-gameserver";
        WorkingDirectory = "/var/lib/satisfactory-gameserver";
        Restart = "on-failure";
      };

      preStart = ''
        ${pkgs.steamcmd}/bin/steamcmd \
          +force_install_dir /var/lib/satisfactory-gameserver/SatisfactoryDedicatedServer \
          +login anonymous \
          +app_update 1690800 \
          validate \
          +quit

        ${pkgs.patchelf}/bin/patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 \
          /var/lib/satisfactory-gameserver/SatisfactoryDedicatedServer/Engine/Binaries/Linux/UnrealServer-Linux-Shipping

        ln -sfv /var/lib/satisfactory-gameserver/.steam/steam/linux64 /var/lib/satisfactory-gameserver/.steam/sdk64
      '';

      script = ''
        /var/lib/satisfactory-gameserver/SatisfactoryDedicatedServer/Engine/Binaries/Linux/UnrealServer-Linux-Shipping FactoryGame -multihome=0.0.0.0
      '';
    };

  };
}

