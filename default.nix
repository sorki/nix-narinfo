{ pkgs ? import <nixpkgs> {} }:
let
  src = pkgs.nix-gitignore.gitignoreSource [ ] ./.;
in
  pkgs.haskell.lib.buildFromSdist
    (pkgs.haskellPackages.callCabal2nix "nix-narinfo" src { })
