{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc883" }:
nixpkgs.haskell.lib.buildFromSdist (nixpkgs.haskell.packages.${compiler}.callCabal2nix "nix-narinfo" ./. { })
