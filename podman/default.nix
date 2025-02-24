{
  lazydocker = import ./lazydocker.nix;

  containers = {
    jellyfin = port: import ./containers/jellyfin.nix { inherit port; };
    calibre-web = port: import ./containers/calibre-web.nix { inherit port; };
    metatube = port: import ./containers/metatube.nix { inherit port; };
  };
}
