{ pkgs, lib, ... }:
{
  imports = with import ../modules; [
    graphical.xfce
  ];

  home.packages = with pkgs; [
    xfce.xfce4-terminal
    xfce.xfce4-taskmanager
    xfce.mousepad
    xfce.ristretto
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
  ];

  home.file = {
    "x.conf".text = ''
      Section "Files"
        ModulePath "/nix/store/nmin18909p8xcrpxjyg757wpqy4rw503-nvidia-x11-575.64.03-6.12.36-bin/lib/xorg/modules/"
        ModulePath "${pkgs.xorg.xf86inputlibinput}/lib/xorg/modules"
        ModulePath "${pkgs.xorg.xorgserver}/lib/xorg/modules"
      EndSection

      Section "Device"
        Identifier "NVIDIA Card"
        Driver "nvidia"
        VendorName "NVIDIA Corporation"
      EndSection

      Section "InputClass"
        Identifier "libinput all devices"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
      EndSection
    '';
    "session.start".text = ''startx -- -config x.conf vt$XDG_VTNR'';
    ".xinitrc".text = ''
      exec startxfce4
    '';
  };
}
