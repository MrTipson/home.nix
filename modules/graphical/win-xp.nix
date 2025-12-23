{
  sources,
  pkgs,
  ...
}:
{
  imports = [ "${sources.win-tc}/packaging/nix/hm.nix" ];

  win-tc = {
    enable = true;
    package = pkgs.callPackage "${sources.win-tc}/packaging/nix/package.nix" { };
  };

  home.packages =
    with pkgs;
    with xfce;
    [
      xorg.xinit
      xorg.xauth
      xorg.xorgserver
      xorg.setxkbmap
      xorg.xinput
      libinput

      tumbler
      exo
      xfconf
      xfce4-xkb-plugin
      xfwm4
      xfce4-settings
      libxfce4ui
      libxfce4util
      libxfce4windowing
      xfce4-icon-theme
      xfce4-pulseaudio-plugin
      xfce4-screensaver
      xfce4-screenshooter
      xfce4-volumed-pulse
      garcon
    ];
}
