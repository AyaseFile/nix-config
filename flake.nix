{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-packages = {
      url = "github:AyaseFile/nur-packages/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      lanzaboote,
      vscode-server,
      nur-packages,
    }:
    let
      inherit (builtins) elem filter;
      inherit (nixpkgs.lib) genAttrs replaceStrings;
      inherit (nixpkgs.lib.filesystem) listFilesRecursive;

      nameOf = path: replaceStrings [ ".nix" ] [ "" ] (baseNameOf (toString path));

      moduleFiles = listFilesRecursive ./modules;
      modules = map nameOf moduleFiles;

      specialModules = [
        "secureboot"
        "vscode-server"
        "pkgs"
        "podman"
        "gnome"
        "kde"
      ];
    in
    {
      modules =
        (genAttrs (filter (name: !(elem name specialModules)) modules) (name: import ./modules/${name}.nix))
        // {
          secureboot = import ./modules/secureboot.nix { inherit lanzaboote; };
          vscode-server = import ./modules/vscode-server.nix { inherit vscode-server; };
          pkgs = import ./modules/pkgs;
          podman = import ./modules/podman;
          gnome = import ./modules/gnome.nix { inherit nur-packages; };
          kde = import ./modules/kde.nix { inherit nur-packages; };
        };
    };
}
