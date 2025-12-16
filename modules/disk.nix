{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkOption
    mkIf
    types
    optional
    mapAttrs
    mapAttrsToList
    filterAttrs
    listToAttrs
    mkMerge
    unique
    flatten
    map
    ;
  cfg = config.modules.disk;
  hasBtrfs = builtins.any (disk: builtins.any (m: m.type == "btrfs") disk.mounts) (
    builtins.attrValues cfg.disks
  );
  mkDevPath = name: disk: if disk.luks then "/dev/mapper/${name}" else "/dev/disk/by-id/${disk.id}";
  mkMountOpts =
    m:
    [ "noatime" ]
    ++ optional (m.type == "btrfs" && m.zstd != null) "compress=zstd:${toString m.zstd}"
    ++ optional (m.type == "btrfs" && m.subvol != null) "subvol=${m.subvol}"
    ++ m.extraOpts;
  mkFs = name: disk: m: {
    name = m.mp;
    value = {
      device = mkDevPath name disk;
      fsType = m.type;
      options = mkMountOpts m;
    };
  };
  mkBind = b: {
    "${b.mp}" = {
      device = b.src;
      fsType = "none";
      options = [ "bind" ] ++ b.extraOpts;
    };
  };
in
{
  options.modules.disk = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    disks = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            id = mkOption { type = types.str; };
            luks = mkOption {
              type = types.bool;
              default = false;
            };
            ssd = mkOption {
              type = types.bool;
              default = true;
            };
            mounts = mkOption {
              type = types.listOf (
                types.submodule {
                  options = {
                    mp = mkOption { type = types.str; };
                    type = mkOption {
                      type = types.enum [
                        "btrfs"
                        "xfs"
                      ];
                      default = "btrfs";
                    };
                    subvol = mkOption {
                      type = types.nullOr types.str;
                      default = null;
                    };
                    zstd = mkOption {
                      type = types.nullOr types.int;
                      default = null;
                    };
                    extraOpts = mkOption {
                      type = types.listOf types.str;
                      default = [ ];
                    };
                  };
                }
              );
              default = [ ];
            };
          };
        }
      );
      default = { };
    };
    binds = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            src = mkOption { type = types.str; };
            mp = mkOption { type = types.str; };
            extraOpts = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
          };
        }
      );
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.luks.devices = mapAttrs (name: disk: {
      device = "/dev/disk/by-id/${disk.id}";
      crypttabExtraOpts = [
        "tpm2-device=auto"
        "tpm2-measure-pcr=yes"
        "password-echo=no"
      ]
      ++ optional disk.ssd "no-read-workqueue"
      ++ optional disk.ssd "no-write-workqueue"
      ++ optional disk.ssd "discard";
    }) (filterAttrs (_: disk: disk.luks) cfg.disks);

    fileSystems = mkMerge [
      (mkMerge (mapAttrsToList (name: disk: listToAttrs (map (mkFs name disk) disk.mounts)) cfg.disks))
      (mkMerge (map mkBind cfg.binds))
    ];

    boot.supportedFilesystems = unique (
      flatten (mapAttrsToList (_: disk: map (m: m.type) disk.mounts) cfg.disks)
    );

    services.btrfs.autoScrub.enable = hasBtrfs;
  };
}
