DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

nix-build --show-trace \
    --argstr rust_overlay `pwd`/nixpkgs-mozilla \
    --arg ruma_src ./ruma \
    default.nix -A ruma
