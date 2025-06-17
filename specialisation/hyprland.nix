{
  inputs,
  pkgs,
  ...
}:
let
  tpkgs = inputs.tipson-pkgs.packages.${pkgs.system};
in
{
  imports =
    with import ../modules;
    with graphical;
    [
      hyprcursor
      hyprland
      hyprland-nvidia
      kitty
      soteria
      swaync
      tofi
      waybar
    ];

  home.packages = with pkgs; [
    uwsm
    wl-clipboard
    hyprshot # screenshot tool
    kdePackages.dolphin
  ];

  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          # nix-shell -p wev --run "wev"
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
          "$mod, q, splitratio, -0.1"
          "$mod, e, splitratio, +0.1"
          "$mod, w, swapwindow, u"
          "$mod, s, swapwindow, d"
          "$mod, a, swapwindow, l"
          "$mod, d, swapwindow, r"
          "$mod, u, togglefloating,"
          "$mod, p, pin,"
          ", Print, exec, hyprshot -m region --clipboard-only"
          "$mod, Print, exec, hyprshot -m window --clipboard-only"
          "$mod, h, exec, uwsm app -T -- zenith"
          "$mod, v, exec, bash -c \"wl-paste > $(${tpkgs.tofi-recursive-file}/bin/tofi-recursive-file --prompt-text='save clipboard to: ')\""
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod Shift, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
              ]
            ) 9
          )
        );
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
    extraConfig = ''
      input {
        kb_layout = si
        follow_mouse = 2
      }
      dwindle {
        split_width_multiplier = 1.5
      }
    '';
  };

  home.file."session.start".text = "uwsm start $(which Hyprland)";
}
