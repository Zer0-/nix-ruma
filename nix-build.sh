DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

nix-build --show-trace \
    --argstr rust_overlay `pwd`/nixpkgs-mozilla \
    --arg ruma_src ./ruma \
    --arg rust_manifests_repo ./rust_manifests \
    default.nix -A ruma
