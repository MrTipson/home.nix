{ pkgs, lib, ... }:
{
  #  stylix.targets.qt.enable = lib.mkForce false;
  #  stylix.targets.kde.enable = lib.mkForce false;
  imports = with import ../modules lib; [
    graphical.kde
  ];

  home.packages = with pkgs; [
    kdePackages.konsole
    kdePackages.dolphin
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
    "session.start".text = ''startx -- -config x.conf vt$XDG_VTNR'';
    ".xinitrc".text = ''
      export DESKTOP_SESSION=KDE
      exec startplasma-x11
    '';
  };
}
