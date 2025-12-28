{
  pkgs,
  lib,
  ...
}:
{
  imports = with import ../modules lib; [ graphical.win-xp ];

  home.packages = with pkgs; [
    xfce.xfce4-power-manager
    xfce.xfce4-terminal
    xfce.xfce4-taskmanager
    xfce.mousepad
    xfce.ristretto
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
  ];

  win-tc = {
    theme = null;
  };

  stylix = {
    cursor = lib.mkForce null;
    autoEnable = false;
    targets = {
      vscode.enable = true;
    };
  };

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
      export DESKTOP_SESSION="WINTC"
      export XDG_CURRENT_DESKTOP="WINTC"
      export WINDEBUG="1"

      xfsettingsd --disable-wm-check --replace --daemon
      xcape -e 'Super_L=Alt_L|F1'

      dbus-run-session -- smss
      exit
    '';
  };
}
