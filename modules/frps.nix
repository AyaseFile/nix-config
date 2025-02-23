{ port, token, ... }:

{
  services.frp = {
    enable = true;
    role = "server";
    settings = {
      bindPort = port;
      auth.token = token;
    };
  };
}
