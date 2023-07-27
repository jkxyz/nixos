# jkxyz/nixos

This repository contains NixOS modules and configurations for my personal machines.

This code is in the public domain. Please feel free to take anything you find useful! ❤️

## Building

The `rebuild` script is provided as an alias for `nixos-rebuild switch --flake . $1 --use-remote-sudo`.

To build the system and switch:

```
$ ./rebuild switch
```

## Optional Packages

Some packages require extra steps to install, or for some other reason I choose not
to install them declaratively, such as taking a long time to build.

These packages are provided as flake outputs, and can be installed imperatively.

### Pianoteq

Pianoteq requires a proprietary binary to be downloaded from a private URL.

To install it, first download the binary from the Pianoteq website, and then add it manually
to the Nix store:

```
$ nix-store --add-fixed sha256 pianoteq/pianoteq_linux_v811.7z
```

Then get the hash of the file and ensure the hash is matching in `pkgs/pianoteq.nix`:

```
$ nix hash file pianoteq/pianoteq_linux_v811.7z
```

Then the package can be installed into a Nix profile with:

```
$ nix profile install .#pianoteq
```
