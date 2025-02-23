{ port, ... }:

{
  networking.firewall.allowedTCPPorts = [
    port
  ];

  virtualisation.oci-containers.containers."jellyfin" = {
    autoStart = true;
    image = "jellyfin/jellyfin:latest";
    user = "1000:100";
    volumes = [
      "/mnt/store/jellyfin/config:/config"
      "/mnt/store/jellyfin/cache:/cache"
      "/mnt/store/jellyfin/media:/media"
    ];
    extraOptions = [
      "--net=host"
      "--group-add=26" # video group
      "--group-add=303" # render group
    ];
  };
}
