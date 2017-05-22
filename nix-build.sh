DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

nix-build --show-trace \
    --arg ruma_src ./ruma \
    --arg rust_nightly $(./build-rust-unstable.sh) \
    default.nix -A ruma
