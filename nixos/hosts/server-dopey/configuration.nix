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

  system.stateVersion = "24.05"; # DO NOT CHANGE
}
