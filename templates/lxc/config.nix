{
  pkgs,
  modulesPath,
  username,
  hostname,
  allowUnfree,
  privileged,
  ...
}:

{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  nix.settings = {
    sandbox = false;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = allowUnfree;

  proxmoxLXC = {
    manageNetwork = false;
    privileged = privileged;
  };

  networking.hostName = hostname;

  time.timeZone = "Asia/Shanghai";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  users.defaultUserShell = pkgs.fish;

  programs.fish = {
    enable = true;
    vendor.config.enable = true;
    vendor.functions.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  networking.firewall.enable = true;

  system.stateVersion = "25.05";
}
