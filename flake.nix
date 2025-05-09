{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nopswd.url = "github:0xkowalskidev/nopswd";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = { allowUnfree = true; }; # Optional: match your main nixpkgs config if needed
      };
    in
    {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          ./nixos/hosts/laptop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.chuwi = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          ./nixos/hosts/chuwi/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          ./nixos/hosts/desktop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.dopey = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          ./nixos/hosts/server-dopey/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      nixosConfigurations.sleepy = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          ./nixos/hosts/server-sleepy/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      homeManagerModules.default = ./home-manager;
    };
}
