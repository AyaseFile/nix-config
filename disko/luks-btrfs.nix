{
  disko.devices = {
    disk = {
      luks-btrfs = {
        type = "disk";
        device = "<disk>";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "system";
                settings = {
                  crypttabExtraOpts = [
                    "tpm2-device=auto"
                    "password-echo=no"
                    "discard"
                  ];
                };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                      ];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                      ];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                      ];
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "noatime"
                        "compress=zstd"
                      ];
                    };
                    "@swap" = {
                      mountpoint = "/swap";
                      mountOptions = [
                        "noatime"
                      ];
                      swap.swapfile.size = "<swap_size>";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
