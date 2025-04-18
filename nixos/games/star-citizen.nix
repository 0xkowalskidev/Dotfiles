{ config, lib, pkgs, inputs, ... }:


{
  options.games.star-citizen.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Star Citizen.";
  };

  config = lib.mkIf config.games.star-citizen.enable
    {
      boot.kernel.sysctl = {
        "vm.max_map_count" = 16777216;
        "fs.file-max" = 524288;
      };

      swapDevices = [{
        device = "/mnt/secondary/swapfile";
        size = 16 * 1024; # 16 GB Swap
      }];

      zramSwap = {
        enable = true;
        memoryMax = 16 * 1024 * 1024 * 1024; # 16 GB ZRAM
      };

      users.users.kowalski = lib.mkMerge [
        {
          packages = [
            (inputs.nix-gaming.packages.${pkgs.hostPlatform.system}.star-citizen.override {

              location = "/mnt/secondary/starcitizen";
              wine = inputs.nix-gaming.packages.${pkgs.hostPlatform.system}.wine-ge;
              tricks = [ "vcrun2019" "arial" "corefonts" "d3dx9" "win10" ];
            })
          ];
        }
      ];
    };

}


