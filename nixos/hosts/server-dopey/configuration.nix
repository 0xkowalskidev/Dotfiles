{ inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common.nix
    ];

  # Boot
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  # Networking
  networking.hostName = "dopey";
  networking.networkmanager.enable = true;

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

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

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    jvmOpts = "-Xmx8G -Xms8G";
    declarative = true;
    serverProperties = {
      motd = "Big Wickes!";
      difficulty = 3;
    };
  };

  system.stateVersion = "24.05"; # DO NOT CHANGE
}
