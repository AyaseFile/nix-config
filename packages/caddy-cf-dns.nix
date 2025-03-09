caddyConfig:
{ pkgs, ... }:

let
  cfg = import caddyConfig;
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.0.0-20250228175314-1fb64108d4de" ];
      hash = "sha256-3nvVGW+ZHLxQxc1VCc/oTzCLZPBKgw4mhn+O3IoyiSs=";
    };
    globalConfig = cfg.globalConfig;
    virtualHosts = cfg.virtualHosts;
  };

  systemd.services.caddy = {
    serviceConfig = {
      EnvironmentFile = "/etc/caddy/.env";
    };
  };
}
