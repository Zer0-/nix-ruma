{ rust_overlay, ruma_src, rust_manifests ? import ./nixpkgs-mozilla/lib/loadManifests.nix }:

let
  nixpkgs = import <nixpkgs> {};
  rustpkgs = import ( builtins.toPath "${rust_overlay}/rust-overlay.nix" ) {
    self = nixpkgs;
    super = { lib = nixpkgs.lib; };
    manifests = rust_manifests;
  };
  jobs = {
    ruma =
      nixpkgs.stdenv.mkDerivation rec {
        name = "ruma";
        buildInputs = [
          nixpkgs.libsodium
          nixpkgs.postgresql.lib
          nixpkgs.openssl
          nixpkgs.clang
          nixpkgs.perl
          rustpkgs.rustChannels.nightly.rust
        ];
        src = ruma_src;
        patches = [ ./patches/update.patch ];
        SSL_CERT_FILE = "${nixpkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        SODIUM_LIB_DIR = "${nixpkgs.libsodium}";
        PQ_LIB_DIR = "${nixpkgs.postgresql.lib}/include";
        LIBCLANG_PATH = "${nixpkgs.clang}/lib";
        RUSTFLAGS = "-L${nixpkgs.openssl.dev}/include/openssl";
        buildPhase = ''
          export CARGO_HOME=.;
          cargo build --verbose
        '';
        installPhase = ''
          mkdir -p $out/bin
          cp target/debug/ruma $out/bin
          chmod +x $out/bin/ruma
        '';
        meta = {
          homepage = "https://www.ruma.io";
          description = "Ruma is a Matrix homeserver written in Rust.";
          platforms = [ "x86_64-linux" ];
        };
      };
  };
in jobs
