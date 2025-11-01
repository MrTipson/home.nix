{
  inputs,
  pkgs,
  lib,
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
      sway
      kitty
      soteria
      swaync
      tofi
      waybar
    ];

  home.packages = with pkgs; [
    wl-clipboard
    hyprshot # screenshot tool
    kdePackages.dolphin
  ];
  wayland.windowManager.sway = {
    config = rec {
      modifier = "Mod4";
      workspaceAutoBackAndForth = true;
      focus.followMouse = false;
      bars = [ ];
      window.titlebar = false;
      keybindings =
        let
          mkMoveBinds = dir: {
            "${modifier}+${dir}" = "focus ${dir}";
            "${modifier}+shift+${dir}" = "move ${dir}";
          };
          mkWorkspaceBinds = i: mkWorkspaceBinds_ (toString (i + 1));
          mkWorkspaceBinds_ = i: {
            "${modifier}+${i}" = "workspace number ${i}";
            "${modifier}+Shift+${i}" = "move container to workspace number ${i}";
          };
        in
        {
          "${modifier}+f" = "exec kitty";
          "${modifier}+c" = "kill";
          "${modifier}+r" = "exec $(tofi-drun)";
          "${modifier}+t" = "exec ${tpkgs.tofi-nix-run}/bin/tofi-nix-run";
          "${modifier}+z" = "fullscreen toggle";
          "${modifier}+u" = "floating toggle";
          "${modifier}+h" = "exec kitty zenith";
          "${modifier}+v" =
            "exec bash -c \"wl-paste > $(${tpkgs.tofi-recursive-file}/bin/tofi-recursive-file --prompt-text='save clipboard to: ')\"";
        }
        // lib.mergeAttrsList (
          map mkMoveBinds [
            "left"
            "right"
            "up"
            "down"
          ]
        )
        // lib.mergeAttrsList (builtins.genList mkWorkspaceBinds 9);
    };
  };

  home.file."session.start".text = "sway";
}
