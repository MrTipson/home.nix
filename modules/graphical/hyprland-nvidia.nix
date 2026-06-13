{ ... }:
{
  wayland.windowManager.hyprland = {
    # https://wiki.hyprland.org/Nvidia/#va-api-hardware-video-acceleration
    extraConfig = ''
      hl.env("LIBVA_DRIVER_NAME", "nvidia")
      hl.env("NVD_BACKEND", "")
    '';
  };
}
