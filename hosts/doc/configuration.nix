{ inputs, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ../../common.nix ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "doc";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # Remote rebuilds
  security.sudo.wheelNeedsPassword = false;

  # NAS
  fileSystems."/data" = {
    device = "/dev/nvme0n1";
    fsType = "btrfs";
    options = [ "noatime" "compress=zstd" ];
  };

  users.groups.nfsusers = { gid = 1000; };

  systemd.tmpfiles.rules = [
    "d /data 0770 nobody nfsusers - -"
  ];

  services.nfs.server = {
    enable = true;
    exports = ''
      /data 192.168.1.0/24(rw,sync,no_subtree_check,all_squash,anonuid=65534,anongid=1000)
    '';
  };

  # Garage (S3-compatible object storage)
  services.garage = {
    enable = true;
    package = pkgs.garage;
    environmentFile = "/etc/garage/env";
    settings = {
      replication_factor = 1;
      db_engine = "lmdb";
      metadata_dir = "/var/lib/garage/meta";
      data_dir = "/data/garage";
      s3_api = {
        s3_region = "garage";
        api_bind_addr = "[::]:3900";
        root_domain = ".s3.garage.localhost";
      };
      s3_web = {
        bind_addr = "[::]:3902";
        root_domain = ".web.garage.localhost";
      };
      admin = {
        api_bind_addr = "[::]:3903";
      };
      rpc_bind_addr = "[::]:3901";
    };
  };

  # Ensure /data/garage exists and garage can traverse /data after mount
  systemd.services.garage-data-dir = {
    description = "Create Garage data directory";
    requiredBy = [ "garage.service" ];
    before = [ "garage.service" ];
    after = [ "data.mount" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/mkdir -p /data/garage";
      ExecStartPost = "${pkgs.coreutils}/bin/chmod o+x /data";
      RemainAfterExit = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 2049 3900 3903 ];

  # User
  users.users.warsmite = {
    isNormalUser = true;
    home = "/home/warsmite";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
