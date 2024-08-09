{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 

    nix-citizen.url = "github:LovingMelody/nix-citizen";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-citizen.inputs.nix-gaming.follows = "nix-gaming";
  };

  outputs = { self, nixpkgs, ... }@inputs: {

    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./nixos/hosts/laptop/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./nixos/hosts/desktop/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };

  };
}
