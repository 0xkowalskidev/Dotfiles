{ config, lib, ... }:


{
  options =
    {
      git.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Git";
      };
    };


  config = lib.mkIf config.git.enable {
    # Git
    programs.git = {
      enable = true;
      userEmail = "0xkowalskidev@gmail.com";
      userName = "0xkowalskidev";

      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
