{
  hostname,
  addr,
  port,
  token,
  ...
}:

{
  services.frp = {
    enable = true;
    role = "client";
    settings = {
      user = hostname;
      serverAddr = addr;
      serverPort = port;
      auth.token = token;
    };
  };
}
