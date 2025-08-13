{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (builtins) filter;
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;

  cfg = config.modules.podman;
  moduleFiles = listFilesRecursive ./.;
  modules = filter (
    path:
    let
      pathStr = toString path;
      fileName = baseNameOf pathStr;
    in
    hasSuffix ".nix" pathStr && fileName != "default.nix" && fileName != "utils.nix"
  ) moduleFiles;
in
{
  imports = modules;

  options.modules.podman = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    user = mkOption {
      type = types.singleLineStr;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
    };

    environment.systemPackages = with pkgs; [
      lazydocker
    ];

    users.users.${cfg.user}.extraGroups = [ "podman" ];
  };
}
