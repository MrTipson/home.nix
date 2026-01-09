#! /usr/bin/env nix-shell
#! nix-shell -i bash -p home-manager
home-manager switch \
  -f . \
  -A homeConfigurations.$HOSTNAME \
  -I home-manager=$(nix eval --raw --file . patchedHM)
