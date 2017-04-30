{ rust_overlay, rust_manifests_repo }:

let
  nixpkgs = import <nixpkgs> {};
  rust_channels = [ "nightly" "beta" "stable" ];
  rust_manifests =
    nixpkgs.lib.attrsets.genAttrs rust_channels (n:
      builtins.toPath "${rust_manifests_repo}/manifests/${n}.toml");
  rustpkgs = import ( builtins.toPath "${rust_overlay}/rust-overlay.nix" )
    nixpkgs  { lib = nixpkgs.lib; manifests = rust_manifests; }; 

in rustpkgs.rustChannels
