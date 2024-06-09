{ lib, inputs, config, ... }:

{
  options = {
    jkxyz.home.users.josh.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable the home-manager modules for desktop user `josh`.
      '';
    };

    jkxyz.home.users.josh.extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = lib.mkMerge [
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }

    (lib.mkIf config.jkxyz.home.users.josh.enable {
      users.users.josh = {
        isNormalUser = true;
        extraGroups = [ "wheel" ] ++ config.jkxyz.home.users.josh.extraGroups;
      };
    })
  ];
}
