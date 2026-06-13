{ pkgs, lib, ... }:
let
  inherit (import ../packages pkgs) tofi-nix-run tofi-recursive-file;
in
{
  imports =
    with import ../modules lib;
    with graphical;
    [
      hyprcursor
      hyprland
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

  # view events: , wev
  wayland.windowManager.hyprland = {
    settings.config.input = {
      kb_layout = "si";
      follow_mouse = 2;
    };
    extraConfig = ''
      local mainMod = "SUPER"

      hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("kitty"))
      hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("$(tofi-drun)"))
      hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("${tofi-nix-run}/bin/tofi-nix-run"))
      hl.bind(mainMod .. " + C", hl.dsp.window.close())

      hl.bind(mainMod .. " + Z", hl.dsp.window.fullscreen({ action = "toggle" }))
      hl.bind(mainMod .. " + U", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + P", hl.dsp.window.pin({ action = "toggle" }))

      hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
      hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"))
      hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("bash -c \"wl-paste > $(${tofi-recursive-file}/bin/tofi-recursive-file --prompt-text='save clipboard to: ')\""))

      -- Move focus with mainMod + arrow keys
      hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
      hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
      hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

      -- Swap windows
      hl.bind(mainMod .. " + A",  hl.dsp.window.swap({ direction = "left" }))
      hl.bind(mainMod .. " + D", hl.dsp.window.swap({ direction = "right" }))
      hl.bind(mainMod .. " + W",    hl.dsp.window.swap({ direction = "up" }))
      hl.bind(mainMod .. " + S",  hl.dsp.window.swap({ direction = "down" }))

      -- Switch workspaces with mainMod + [0-9]
      -- Move active window to a workspace with mainMod + SHIFT + [0-9]
      for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
          hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
      end

      -- Move/resize windows with mainMod + LMB/RMB and dragging
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    '';
  };

  home.file."session.start".text = "start-hyprland";
}
