{ config, pkgs, ... }:
{
  services.wpaperd = {
    enable = true;
    settings."default".path = config.stylix.image;
  };

  home.packages = with pkgs; [
    niri
    xwayland-satellite
    xdg-desktop-portal-gtk
  ];

  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "xwayland-satellite"
    input {
        keyboard {
            xkb {
                layout "si"
            }

            numlock
        }

        // Focus windows and outputs automatically when moving the mouse into them.
        // Setting max-scroll-amount="0%" makes it work only on windows already fully on screen.
        // focus-follows-mouse max-scroll-amount="0%"
    }

    layout {
        gaps 8
        center-focused-column "never"

        // You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 1.0
        }

        default-column-width { proportion 0.5; }

        border {
            width 2
            ${with config.lib.stylix.colors.withHashtag; ''
              active-color "${base0D}"
              inactive-color "${base03}"
              urgent-color "${base08}"
            ''}
        }

        focus-ring {
            off
        }
    }
    prefer-no-csd
    screenshot-path null

    environment {
        DISPLAY ":0"
    }
  '';
}
