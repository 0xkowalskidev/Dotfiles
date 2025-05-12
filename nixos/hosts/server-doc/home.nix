{ ... }:

{
  nixpkgs.config.allowUnfree = true;

  neovim.enable = true;
  bash.enable = true;
  git.enable = true;
}
