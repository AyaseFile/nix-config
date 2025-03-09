frpsConfig:

let
  cfg = import frpsConfig;
in
{
  services.frp = {
    enable = true;
    role = "server";
    settings = {
      bindPort = cfg.port;
      auth.token = cfg.token;
    };
  };
}
