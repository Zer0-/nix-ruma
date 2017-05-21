DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

nix-build --show-trace \
    --keep-failed \
    --argstr rust_overlay `pwd`/nixpkgs-mozilla \
    --arg rust_manifests_repo ./rust_manifests \
    rust-channels.nix -A nightly.rust

