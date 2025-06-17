{ ... }:
{
  xdg.configFile."niri/config.kdl".text = ''
    output "DP-4" {
        mode "2560x1440@240"

        scale 1
        transform "normal"

        position x=0 y=0
    }
  '';
}
