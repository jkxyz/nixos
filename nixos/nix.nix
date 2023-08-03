{ lib, config, ... }:

{
  options = {
    jkxyz.nix.persistDerivations = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable setting keep-derivations and keep-outputs to true to prevent shells from getting garbage collected.
      '';
    };
  };

  config = {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];

      # TODO Make conditional
      keep-outputs = true;
      keep-derivations = true;
    };
  };

}
