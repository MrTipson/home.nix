{ writeShellApplication,
  tofi,
  jq,
  prompt ? "run nixpkgs package: ",
  cacheLocation ? "$XDG_CACHE_HOME/tofi-nix-run",
}: writeShellApplication {
  name = "tofi-nix-run";
  runtimeInputs = [ tofi jq ];
  text = ''
    hash=$(nix eval --expr "(builtins.getFlake flake:nixpkgs).narHash" --impure)

    if [[ $hash != $(cat "${cacheLocation}/hash") ]]; then
      mkdir -p "${cacheLocation}"
      nix search nixpkgs ^ --json | jq -r 'keys[]' > "${cacheLocation}/pkgs"
      echo "$hash" > "${cacheLocation}/hash"
    fi

    pkg=$(tofi < "${cacheLocation}/pkgs" \
      --require-match=false \
      --prompt-text='${prompt}' \
      --num-results=0)

    if [[ -z $pkg ]]; then
      exit 0
    fi
    # shellcheck disable=SC2206
    pkg=($pkg)
    uwsm app -- kitty --hold nix run nixpkgs#"''${pkg[0]}" -- "''${pkg[@]:1}"
    '';
}