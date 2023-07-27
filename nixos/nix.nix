{ ... }:

{
  # Reference: https://nixos.org/manual/nix/stable/command-ref/conf-file.html
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    # Don't gc outputs to speed up dev shell evaluation
    # TODO Enable this under a custom NixOS option
    keep-outputs = true;
    keep-derivations = true;
  };
}
