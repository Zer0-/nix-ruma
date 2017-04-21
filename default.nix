{ rust_overlay, ruma_src }:

let
  nixpkgs = import <nixpkgs> {};
  rustpkgs = import ./nixpkgs-mozilla/rust-overlay.nix nixpkgs {
    lib = nixpkgs.lib;
  };
  jobs = {
    ruma =
      nixpkgs.stdenv.mkDerivation rec {
        name = "ruma-alpha";
        buildInputs = [
          nixpkgs.libsodium
          nixpkgs.postgresql.lib
          nixpkgs.openssl
          nixpkgs.clang
          nixpkgs.perl
          rustpkgs.rustChannels.nightly.rust
        ];
        /*
        src = nixpkgs.fetchgit {
          url = "https://github.com/ruma/ruma.git";
          #rev = "8eda5e5006d9162be1d0fcac0404092be5ec0277";
          #sha256 = "00qn7in3h7wwm1s79qyjnfbhjhpclbnhq7g0kphkgf7p6kvy6phy";
          sha256 = "14ik2rg30xgpjw4bxqzz728bx915pl1d24zpmvl3zn18301i03iy";
        };
        */
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
