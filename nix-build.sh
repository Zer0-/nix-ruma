DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

nix-build --show-trace \
    --arg rust_overlay ./nixpkgs-mozilla/rust-overlay.nix \
    --arg ruma_src ./ruma \
    default.nix -A ruma
