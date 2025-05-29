{ inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ../../common.nix ];

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
    options = [ "rw" "sync" ];
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

  # DNS
  services.dnsmasq = {
    enable = true;
    settings = {
      address = [
        "/dopey/192.168.1.69"
	"/doc/192.168.1.129"
	"/sleepy/192.168.1.102"
	"/grumpy/192.168.1.184"
      ];
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
