{ inputs, ... }:

{
  imports =
    [
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

  # Gitlab
  services.gitlab = {
    enable = true;
    https = true;
    host = "gitlab.0xkowalski.dev";
    port = 443;
  };

  # Container Registry
  services.dockerRegistry = {
    enable = true;
  };

  services.caddy = {
    enable = true;
    virtualHosts."registry.0xkowalski.dev" = {
      extraConfig = ''
        reverse_proxy localhost:5000
      '';
    };
    virtualHosts."0xkowalski.0xkowalski.dev" = {
      extraConfig = ''
        reverse_proxy localhost:443
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Home Manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };

    users = {
      "kowalski" = { ... }: {
        imports = [
          ./home.nix
          inputs.self.outputs.homeManagerModules.default
        ];
      };
    };
  };

  system.stateVersion = "24.05"; # DO NOT CHANGE
}
