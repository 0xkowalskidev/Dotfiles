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
  networking.hostName = "sleepy";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

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

  # DDNS
  services.ddclient = {
    enable = true;
    interval = "1min";
    protocol = "cloudflare";
    ssl = true;
    username = "token";
    passwordFile = "/etc/nixos/ddns-token";
    zone = "0xkowalski.dev";
    domains = [ "@" ];
  };

  # Github runners
  services.github-runners = {
    vaai = {
      enable = true;
      url = "https://github.com/0xkowalskidev/VirtualAdminTrainer";
      tokenFile = "/var/lib/vaai.env";
      name = "vaai";
      user = "vaai";
      group = "vaai";
      serviceOverrides = {
        ReadWritePaths = [ "/srv/vaai" ];
      };
    };
  };

  users.users.vaai = {
    isSystemUser = true;
    group = "vaai";
  };
  users.groups.vaai = { };

  systemd.tmpfiles.rules = [ "d /srv/vaai 0755 vaai vaai -" ];

  systemd.services.vaai = {
    description = "Virtual Admin Trainer Go Application";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "vaai";
      Group = "vaai";
      WorkingDirectory = "/srv/vaai";
      ExecStart = "/srv/vaai/vaai";
      Restart = "always";
      RestartSec = "5s";
      EnvironmentFile = "/etc/vaai/vaai.env";
    };
  };

  systemd.paths."vaai-restarter" = {
    description = "Watch for new vaai binary to trigger a restart";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathChanged = "/srv/vaai/vaai"; # Monitor the vaai binary specifically
    };
  };

  systemd.services."vaai-restarter" = {
    description = "Restart vaai service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl restart vaai.service";
      StartLimitIntervalSec = 60;
      StartLimitBurst = 10;
    };
  };

  # Backup DB
  systemd.services.sqlite-backup = {
    description = "Backup SQLite database";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c 'cp /srv/vaai/sqlite.db /mnt/data/vaai/backup-$$(date +%%Y%%m%%d%%H%%M%%S).db'";
      User = "root"; # Adjust user if needed
    };
  };

  systemd.timers.sqlite-backup = {
    description = "Timer for SQLite database backup";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "hourly"; # Runs every hour
      Persistent = true; # Runs missed backups
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services.caddy = {
    enable = true;
    virtualHosts."0xkowalski.dev".extraConfig = ''
      reverse_proxy localhost:3000
    '';
    virtualHosts."online-portal.myfreelanceadmin.com".extraConfig = ''
      reverse_proxy localhost:3000
    '';
  };

  # User
  users.users.kowalski = {
    isNormalUser = true;
    home = "/home/kowalski";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
