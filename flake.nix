{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";

    nopswd.url = "github:0xkowalskidev/nopswd";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    {
      # User machines
      nixosConfigurations.chuwi = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/chuwi/configuration.nix
	  inputs.home-manager.nixosModules.home-manager
        ];
      };

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/desktop/configuration.nix
	  inputs.home-manager.nixosModules.home-manager
        ];
      };

      # Servers
      nixosConfigurations.dopey = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/server-dopey/configuration.nix
        ];
      };

      nixosConfigurations.sleepy = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/server-sleepy/configuration.nix
        ];
      };

      nixosConfigurations.doc = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/server-doc/configuration.nix
        ];
      };

      nixosConfigurations.grumpy = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/server-grumpy/configuration.nix
        ];
      };
    };
}
