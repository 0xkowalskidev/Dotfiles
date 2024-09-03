{ config, lib, pkgs, ... }:

{
  options.games.minecraft.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Prismlauncher for Minecraft";
  };

  config = lib.mkIf config.games.minecraft.enable {
    environment.systemPackages = with pkgs; [
      openjdk21
      prismlauncher
    ];
  };
}




