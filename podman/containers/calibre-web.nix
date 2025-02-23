{ port, ... }:

{
  networking.firewall.allowedTCPPorts = [
    port
  ];

  virtualisation.oci-containers.containers."calibre-web" = {
    autoStart = true;
    image = "linuxserver/calibre-web:latest";
    volumes = [
      "/mnt/store/calibre/config:/config"
      "/mnt/store/calibre/books:/books"
    ];
    ports = [ "${toString port}:8083" ];
    environment = {
      PUID = "1000";
      PGID = "100";
      TZ = "Asia/Shanghai";
    };
  };
}
