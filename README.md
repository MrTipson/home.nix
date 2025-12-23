Welcome to my home manager configuration! I hold some strong stances regarding nix and how and where things belong, which means I do a couple of funky things in my configs.

It boils down to the mantra that every user should be able to modify and build their config independently of other users[^1], which has some interesting consequences:
- it necessitates the standalone usage of home manager
- it prevents the usage of display managers
- it complicates the usage of desktop environments
- it imposes a strong separation of system and user settings (which is a good thing!)
- patching the host's nix package to allow local registry resolution[^2]

Even if you don't care about this stuff, here are a couple of interesting things I do that might be of interest:
- setting up home-manager specialisations ([specialisation.nix](https://github.com/MrTipson/home.nix/blob/master/modules/terminal/specialisation.nix))
- DE/WM specific [specialisations](https://github.com/MrTipson/home.nix/tree/master/specialisation) (check their corresponding [modules](https://github.com/MrTipson/home.nix/tree/master/modules/graphical) as well)
- tofi scripts for (they are exposed in a flake, you can try them out with tomething like `nix run --no-write-lock-file  "github:mrtipson/home.nix?dir=packages#tofi-nix-run"`):
    - quickly launching applications from nixpkgs ([tofi-nix-run.nix](https://github.com/MrTipson/home.nix/blob/master/packages/tofi-nix-run.nix))
    - recursively picking a file ([tofi-recursive-file.nix](https://github.com/MrTipson/home.nix/blob/master/packages/tofi-recursive-file.nix))

## Npins
I've recently switched from flakes to npins, but I wanted to keep the flake output structure. I don't know if there is a better way, but I ended up [patching](./flake-like-entrypoint.patch) home-manager to do what I want. Then all you need is to bootstrap so home-manager starts using the patched version: `home-manager switch -f ... -A ... -I home-manager=$(nix-instantiate --eval --raw -A patchedHM)`, and setup home manager so it manages itself:
```nix
programs.home-manager = {
    enable = true;
    path = lib.mkForce (import ./. { inherit sources; }).patchedHM;
};
```

---

[^1] This doesn't mean that it doesn't affect you if you have only a single user. For me it helps with choosing the correct abstraction if I think about making it user agnostic.

[^2] Because some people hate fun, they broke local registry evaluation for flake inputs, which is why I now patch `nix` on the host system (see [registry.nix](https://github.com/MrTipson/systems.nix/blob/master/modules/registry.nix)).