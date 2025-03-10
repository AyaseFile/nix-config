{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.tailscale;
in
{
  options.modules.tailscale = {
    enable = mkEnableOption "Node agent for Tailscale, a mesh VPN built on WireGuard";
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}
