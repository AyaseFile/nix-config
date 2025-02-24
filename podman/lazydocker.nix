{ pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    lazydocker
  ];
  virtualisation.podman.dockerSocket.enable = true;
  users.users.${username}.extraGroups = [ "podman" ];
}
