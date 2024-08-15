{ config, lib, ... }:


{
  options =
    {
      bash.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Bash";
      };
    };


  config = lib.mkIf config.bash.enable {
    # Bash
    programs.bash = {
      enable = true;
      initExtra = ''
        ssh-add ~/.ssh/github_rsa
        clear
      '';
    };

    # Direnv
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
