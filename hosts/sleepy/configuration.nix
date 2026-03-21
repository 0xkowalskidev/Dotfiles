{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
    inputs.gamejanitor.nixosModules.default
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
  services.openssh.settings.PasswordAuthentication = false;

  # Remote rebuilds
  security.sudo.wheelNeedsPassword = false;

  # DDNS
  services.ddclient = {
    enable = true;
    interval = "1min";
    protocol = "cloudflare";
    ssl = true;
    username = "token";
    passwordFile = "/etc/nixos/ddns-token";
    zone = "warsmite.com";
    domains = [ "warsmite.com" ];
  };

  # Gamejanitor controller (temporarily disabled - vendor issue)
  #services.gamejanitor = {
  #  enable = true;
  #  role = "controller";
  #  port = 8080;
  #  grpcPort = 9090;
  #  sftpPort = 2022;
  #  openFirewall = true;
  #};

  # SearXNG
  services.searx = {
    enable = true;
    environmentFile = "/etc/nixos/searxng-secret";
    settings = {
      server = {
        port = 8888;
        bind_address = "0.0.0.0";
        secret_key = "$SEARX_SECRET_KEY";
      };
      search = {
        default_lang = "en";
        formats = [ "html" "json" ];
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 8888 ];

  # User
  users.users.warsmite = {
    isNormalUser = true;
    home = "/home/warsmite";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
