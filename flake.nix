{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = { self, nixpkgs, ... }@inputs: {

    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/hosts/laptop/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/hosts/desktop/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };

    nixosConfigurations.dopey = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/hosts/server-dopey/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };

    homeManagerModules.default = ./home-manager;
  };
}
