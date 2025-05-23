{ inputs, config, pkgs, lib, myconfig, ... }: let
  tpkgs = inputs.tipson-pkgs.packages.${pkgs.system};
in {
  imports = with import ./modules; [
    terminal.fish
    terminal.television

    ssh.github
    ssh.minipc
    ssh.rpi
  ] ++ lib.optionals myconfig.graphical (with graphical; [
    discord
    firefox
    hyprcursor
    hyprland
    hyprland-nvidia
    kitty
    mpv
    obs-studio
    pipewire
    soteria
    spotify
    stylix-qt
    stylix
    swaync
    tofi
    vscode
    waybar
  ]);
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tipson";
  home.homeDirectory = "/home/tipson";

  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    zenith-nvidia # hardware monitor
    tldr
  ] ++ lib.optionals myconfig.graphical [
    wl-clipboard
    hyprshot # screenshot tool
    mangohud # hardware overlay
    ffmpeg
    xdg-utils
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.git = {
    enable = true;
    userName = "MrTipson";
    userEmail = "mr@tipson.xyz";
  };

  home.file = {
    ".sops.yaml".text = ''
      keys:
        - &mrtipson age1lp6w8qkkzcuvgz6md0wjc98e60nky3exme7uaz232mza7vqts95q824yeg
      creation_rules:
        - path_regex: secrets/[^/]+\.(yaml|json|env|ini)$
          key_groups:
          - age:
            - *mrtipson
    '';
  };

  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = "SUPER";
      bind = [ # nix-shell -p wev --run "wev"
        "$mod, F, exec, uwsm app -- kitty"
        "Control Alt, Delete, exec, uwsm stop --"
        "$mod, R, exec, uwsm app -- $(tofi-drun)"
        "$mod, T, exec, ${tpkgs.tofi-nix-run}/bin/tofi-nix-run"
        "$mod, C, killactive,"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, z, fullscreen,"
        "$mod, a, splitratio, -0.1"
        "$mod, d, splitratio, +0.1"
        "$mod, u, togglefloating,"
        ", Print, exec, hyprshot -m region --clipboard-only"
        "$mod, Print, exec, hyprshot -m window --clipboard-only"
        "$mod, s, exec, uwsm app -- dolphin"
        "$mod, h, exec, uwsm app -T -- zenith"
        "$mod, v, exec, bash -c \"wl-paste > $(${tpkgs.tofi-recursive-file}/bin/tofi-recursive-file --prompt-text='save clipboard to: ')\""
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod Shift, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
            ]
          )
        9)
      );
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
    extraConfig = ''
      input {
        kb_layout = si
      }
      dwindle {
        split_width_multiplier = 1.5
      }
    '';
  };


  programs.fish.loginShellInit = ''${tpkgs.user-desktop-select.override {
    desktops = {
      Hyprland = "uwsm start $(which Hyprland)";
    };
  }}'';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
