{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
    minimal-tmux = {
      url = "github:niksingh710/minimal-tmux-status";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nopswd.url = "github:0xkowalskidev/nopswd";
    gameserverquery.url = "github:0xkowalskidev/gameserverquery";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      # User machines
      nixosConfigurations.chuwi = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/chuwi/configuration.nix
          inputs.home-manager.nixosModules.home-manager
        ];
      };

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop/configuration.nix
          inputs.home-manager.nixosModules.home-manager
        ];
      };

      nixosConfigurations.ace = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/ace/configuration.nix
          inputs.home-manager.nixosModules.home-manager
        ];
      };

      # Servers
      nixosConfigurations.dopey = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/dopey/configuration.nix ];
      };

      nixosConfigurations.sleepy = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/sleepy/configuration.nix ];
      };

      nixosConfigurations.doc = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/doc/configuration.nix ];
      };

      nixosConfigurations.grumpy = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/grumpy/configuration.nix ];
      };
    };
}
