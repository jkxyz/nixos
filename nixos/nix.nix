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
    } // lib.mkIf config.jkxyz.nix.persistDerivations {
      keep-outputs = true;
      keep-derivations = true;
    };
  };

}
