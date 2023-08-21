#!/usr/bin/env bash

set -e

if [[ "$1" == "all" ]]; then
    nix flake lock \
        --update-input nixpkgs \
        --update-input nixpkgs-unstable \
        --update-input nixos-hardware \
        --update-input home-manager \
        --update-input nixpkgs-mozilla
else
    nix flake lock \
        --update-input nixpkgs-unstable
fi
