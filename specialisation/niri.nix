{
  inputs,
  pkgs,
  config,
  ...
}:
let
  tpkgs = inputs.tipson-pkgs.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports =
    with import ../modules;
    with graphical;
    [
      hyprcursor
      kitty
      niri
      soteria
      swaync
      tofi
      waybar
    ];

  xdg.configFile."niri/config.kdl".text = ''
    // Example: block out two password managers from screen capture.
    // (This example rule is commented out with a "/-" in front.)
    /-window-rule {
        match app-id=r#"^org\.keepassxc\.KeePassXC$"#
        match app-id=r#"^org\.gnome\.World\.Secrets$"#

        block-out-from "screen-capture"

        // Use this instead if you want them visible on third-party screenshot tools.
        // block-out-from "screencast"
    }

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        // Suggested binds for running programs: terminal, app launcher, screen locker.
        Mod+F hotkey-overlay-title="Open a Terminal" { spawn "bash" "-c" "uwsm app -T"; }
        Mod+R hotkey-overlay-title="Run an Application" { spawn "bash" "-c" "uwsm app -- $(tofi-drun)"; }
        Mod+V hotkey-overlay-title="Run an Application" { spawn "bash" "-c" "wl-paste > $(${tpkgs.tofi-recursive-file}/bin/tofi-recursive-file --prompt-text='save clipboard to: ')"; }
        Super+Alt+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn "swaylock"; }

        // You can also use a shell. Do this if you need pipes, multiple commands, etc.
        // Note: the entire command goes as a single argument in the end.
        Mod+T { spawn "bash" "-c" "${tpkgs.tofi-nix-run}/bin/tofi-nix-run"; }

        // Open/close the Overview: a zoomed-out view of workspaces and windows.
        // You can also move the mouse into the top-left hot corner,
        // or do a four-finger swipe up on a touchpad.
        Mod+O repeat=false { toggle-overview; }

        Mod+C { close-window; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }

        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Right { move-column-right; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        Mod+Shift+Left  { focus-monitor-left; }
        Mod+Shift+Down  { focus-monitor-down; }
        Mod+Shift+Up    { focus-monitor-up; }
        Mod+Shift+Right { focus-monitor-right; }

        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }

        // Alternatively, there are commands to move just a single window:
        // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
        // ...

        // And you can also move a whole workspace to another monitor:
        // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
        // ...

        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }

        // Alternatively, there are commands to move just a single window:
        // Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
        // ...

        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }

        ${builtins.concatStringsSep "\n" (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            ''
              Mod+${toString ws} { focus-workspace ${toString ws}; }
              Mod+Shift+${toString ws} { move-column-to-workspace ${toString ws}; }
              Mod+Ctrl+${toString ws} { move-window-to-workspace ${toString ws}; }
            ''
          ) 9
        )}

        Mod+Tab { focus-workspace-previous; }

        Mod+A  { consume-or-expel-window-left; }
        Mod+D { consume-or-expel-window-right; }

        Mod+Y  { consume-window-into-column; }
        // Expel the bottom window from the focused column to the right.
        Mod+X { expel-window-from-column; }

        Mod+Shift+S { switch-preset-column-width; }
        Mod+G { maximize-column; }
        Mod+Z { fullscreen-window; }
        
        Mod+Space { expand-column-to-available-width; }

        Mod+B { center-column; }

        Mod+Q { set-column-width "-10%"; }
        Mod+E { set-column-width "+10%"; }

        // Finer height adjustments when in column with other windows.
        Mod+S { set-window-height "-10%"; }
        Mod+W { set-window-height "+10%"; }

        // Move the focused window between the floating and the tiling layout.
        Mod+U       { toggle-window-floating; }

        // Toggle tabbed column display mode.
        // Windows in this column will appear as vertical tabs,
        // rather than stacked on top of each other.
        Mod+Shift+W { toggle-column-tabbed-display; }

        // Actions to switch layouts.
        // Note: if you uncomment these, make sure you do NOT have
        // a matching layout switch hotkey configured in xkb options above.
        // Having both at once on the same hotkey will break the switching,
        // since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
        // Mod+Space       { switch-layout "next"; }
        // Mod+Shift+Space { switch-layout "prev"; }

        Print { screenshot; }
        Mod+Print { screenshot-window; }

        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        Ctrl+Alt+Delete { quit; }
        Mod+Shift+P { power-off-monitors; }
    }
  '';

  home.packages = with pkgs; [
    wl-clipboard
    kdePackages.dolphin
    uwsm
  ];

  home.file."session.start".text = "uwsm start (which niri) -- --session";
}
