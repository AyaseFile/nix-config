{
  self,
  pkgs,
  username,
  uid,
  allowUnfree,
  ...
}:

{
  nix.enable = true;
  nix.settings = {
    sandbox = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = allowUnfree;

  users.knownUsers = [ username ];
  users.users.${username} = {
    uid = uid;
    shell = pkgs.fish;
  };

  programs.fish = {
    enable = true;
    vendor.config.enable = true;
    vendor.functions.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
}
