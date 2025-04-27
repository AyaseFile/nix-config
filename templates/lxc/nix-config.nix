{ flake, nix-mods, ... }:

{
  imports = [ nix-mods.pkgs ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 3d --keep 3";
    flake = flake;
  };

  modules.pkgs.cli.enable = true;
}
