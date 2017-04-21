DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

nix-shell --show-trace \
    --arg rust_overlay ./nixpkgs-mozilla/rust-overlay.nix \
    default.nix \
    --pure
