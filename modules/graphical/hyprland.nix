{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      env = [
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "XCURSOR_THEME,${config.stylix.cursor.name}"
        "XCURSOR_SIZE,${builtins.toString config.stylix.cursor.size}"
      ];
      general.gaps_out = 10;
      decoration = {
        blur.enabled = false;
        shadow.enabled = false;
      };
      input = {
        repeat_rate = 50;
        repeat_delay = 300;
        follow_mouse = 0;
      };
      animation = [
        "global, 1, 3, default"
      ];
      windowrule = [
        "decorate, 0, title:(.*)"
      ];
    };
    extraConfig = ''
      input {
        numlock_by_default = true
      }
    '';
  };
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
