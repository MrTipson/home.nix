{
  config,
  pkgs,
  lib,
  ...
}:
{
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
      xfce4-session
      xfce4-settings
      libxfce4ui
      libxfce4util
      libxfce4windowing
      xfce4-notifyd
      xfce4-icon-theme
      xfce4-panel
      xfce4-panel-profiles
      xfce4-pulseaudio-plugin
      xfce4-screensaver
      xfce4-screenshooter
      xfce4-volumed-pulse
      garcon
    ];
}
