{ lib, ... }:

let
  inherit (builtins) filter;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;

  moduleFiles = listFilesRecursive ./.;
  modules = filter (
    path:
    let
      pathStr = toString path;
      fileName = baseNameOf pathStr;
    in
    hasSuffix ".nix" pathStr && fileName != "default.nix"
  ) moduleFiles;
in
{
  imports = modules;
}
