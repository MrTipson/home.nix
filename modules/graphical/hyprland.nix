{ lib, pkgs, config, ... }:
{
  home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      config = {
        input = {
          numlock_by_default = true;
          repeat_rate = 50;
          repeat_delay = 300;
          follow_mouse = lib.mkDefault 0;
        };
        general.gaps_out = 10;
        decoration = {
          blur.enabled = false;
          shadow.enabled = false;
        };
        dwindle.split_width_multiplier = 1.5;
      };
      window_rule = {
        match.title = ".*";
        decorate = false;
      };
    };
    extraConfig = ''
      hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
      hl.env("XCURSOR_THEME", "${config.stylix.cursor.name}")
      hl.env("XCURSOR_SIZE", "${builtins.toString config.stylix.cursor.size}")

      hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "default" })
    '';
  };
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
