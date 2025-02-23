{ port, ... }:

{
  networking.firewall.allowedTCPPorts = [
    port
  ];

  virtualisation.oci-containers.containers."metatube" = {
    autoStart = true;
    image = "metatube/metatube-server:latest";
    user = "1000:100";
    volumes = [
      "/mnt/store/metatube/config:/config"
    ];
    ports = [ "${toString port}:8080" ];
    cmd = [
      "-dsn"
      "/config/metatube.db"
    ];
  };
}
