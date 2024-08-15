{ pkgs, config, lib, ... }:


{
  options =
    {
      brave.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Brave browser";
      };
    };


  config = lib.mkIf config.brave.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        # Vimium
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
        # Video Speed Controller
        { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; }
        # Remove Youtube Shorts
        { id = "mgngbgbhliflggkamjnpdmegbkidiapm"; }
        # UBlock Origin
        { id = "epcnnfbjfcgphgdmggkamkmgojdagdnn"; }
        # Sponsor Block
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
        # Return Youtube Dislikes
        { id = "gebbhagfogifgggkldgodflihgfeippi"; }
      ];
    };

  };
}
