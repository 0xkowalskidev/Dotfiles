{ config, lib, pkgs, ... }:

{
  options.games.lutris.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Lutris";
  };

  config = lib.mkIf config.games.lutris.enable {
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


    environment.systemPackages = with pkgs; [
      wineWowPackages.stable
      winetricks
      libwebp

      lutris
    ];
  };
}




