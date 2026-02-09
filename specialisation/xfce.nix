{ pkgs, lib, ... }:
{
  imports = with import ../modules lib; [
    graphical.xfce
  ];

  home.packages = with pkgs; [
    xfce4-terminal
    xfce4-taskmanager
    mousepad
    ristretto
    thunar
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-volman
  ];

  home.file = {
    "x.conf".text = ''
      Section "Files"
        ModulePath "${pkgs.xorg.xf86inputlibinput}/lib/xorg/modules"
        ModulePath "${pkgs.xorg.xorgserver}/lib/xorg/modules"
      EndSection

      Section "InputClass"
        Identifier "libinput all devices"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
      EndSection
    '';
    "session.start".text = "startx -- -config x.conf vt$XDG_VTNR";
    ".xinitrc".text = ''
      exec startxfce4
    '';
  };
}
