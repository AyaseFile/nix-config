frpcConfig:

let
  cfg = import frpcConfig;
in
{
  services.frp = {
    enable = true;
    role = "client";
    settings = {
      user = cfg.user;
      serverAddr = cfg.addr;
      serverPort = cfg.port;
      auth.token = cfg.token;
      proxies = cfg.proxies;
    } // cfg.settings;
  };
}
