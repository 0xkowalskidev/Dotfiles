{ inputs, ... }:

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
  services.openssh.settings.PasswordAuthentication = true;

  # NAS
  fileSystems."/data" = {
    device = "/dev/nvme0n1";
    fsType = "btrfs";
    options = [ "noatime" "compress=zstd" ];
  };

  users.groups.nfsusers = { gid = 1000; };

  # Set permissions for /data and subdirectories
  systemd.tmpfiles.rules = [
    "d /data 0770 nobody nfsusers - -" # Root /data directory
  ];

  services.nfs.server = {
    enable = true;
    exports = ''
      /data 192.168.1.0/24(rw,sync,no_subtree_check,all_squash,anonuid=65534,anongid=1000)
    '';
  };

  networking.firewall.allowedTCPPorts = [ 2049 ];

  # User
  users.users.kowalski = {
    isNormalUser = true;
    home = "/home/kowalski";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
