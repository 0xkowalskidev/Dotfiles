{ config, lib, pkgs, inputs, ... }:

{
  options.games.star-citizen.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Star Citizen.";
  };

  config = lib.mkIf config.games.star-citizen.enable {
    # Nix-gaming cache
    nix.settings = {
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };

    environment.systemPackages = with pkgs; [
      inputs.nix-citizen.packages.${system}.star-citizen
    ];
  };
}




