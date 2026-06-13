{ ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        # hyprctl monitors
        { output = "DP-4"; mode = "2560x1440@240"; position = "0x0"; scale = 1; }
        { output = "DVI-D-1"; mode = "1920x1080"; position = "2560x0"; scale = 1; }
        { output = "Unknown-1"; disabled = true; }
        { output = ""; mode = "preferred"; position = "auto"; scale = 1; } # catch all for random monitors
      ];
    };
  };
}
