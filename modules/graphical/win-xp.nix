{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  win-tc = inputs.win-tc.packages.${pkgs.system};
in
{
  imports = [ ./xfce.nix ];

  home.pointerCursor = {
    enable = true;
    name = "Windows XP Standard (with pointer shadows)";
    package = win-tc.cursors.with-shadow.standard;
  };

  gtk.gtk3 = {
    iconTheme = {
      name = "luna";
      package = win-tc.icons.luna;
    };
    theme = {
      name = "Windows XP style (Blue)";
      package = win-tc.themes.luna.blue;
    };
  };

  xfconf.settings = {
    "xfwm4" = {
      "general/title_font" = "Trebuchet MS Bold 10";
      "general/title_alignment" = "left";
      "general/show_dock_shadow" = false;
      "general/show_popup_shadow" = false;
      "general/show_app_icon" = false;
    };
    "xfce4-keyboard-shortcuts" = {
      "commands/custom/<Super>r" = "run";
      "commands/custom/<Alt>F1" = "wintc-taskband --start";
    };
    "xsettings" = {
      "Net/EnableEventSounds" = true;
      "Net/EnableInputFeedbackSounds" = true;
      "Net/SoundThemeName" = "Windows XP Default";
      "Net/IconThemeName" = "luna";
      "Xfce/SyncThemes" = true;
    };
  };

  xdg.mime.enable = true;
  xdg.autostart = {
    enable = true;
    entries = [
      (pkgs.writeText "WinTC Desktop.desktop" ''
        [Desktop Entry]
        Encoding=UTF-8
        Version=0.9.4
        Type=Application
        Name=WinTC Desktop
        Comment=
        Exec=${win-tc.shell.desktop}/bin/wintc-desktop
        OnlyShowIn=XFCE;
        RunHook=0
        StartupNotify=false
        Terminal=false
        Hidden=false
      '')
      (pkgs.writeText "WinTC Taskband.desktop" ''
        [Desktop Entry]
        Encoding=UTF-8
        Version=0.9.4
        Type=Application
        Name=WinTC Taskband
        Comment=
        Exec=${win-tc.shell.taskband}/bin/wintc-taskband
        OnlyShowIn=XFCE;
        RunHook=0
        StartupNotify=false
        Terminal=false
        Hidden=false
      '')
    ];
  };

  home.packages =
    with pkgs;
    with win-tc;
    [
      icons.luna
      themes.luna.blue

      xfce.xfce4-power-manager
      xcape
      base.bldtag
      base.regsvc
      base.smss
      shell.cpl.desk
      shell.cpl.printers
      shell.cpl.sysdm
      shell.desktop
      shell.exitwin
      shell.explorer
      shell.run
      shell.shext.zip
      shell.taskband
      shell.winver
      wallpapers
      windows.notepad
      windows.taskmgr
    ];
}
