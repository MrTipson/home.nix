{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cosmic-bg
    cosmic-osd
    cosmic-comp
    cosmic-idle
    cosmic-icons
    cosmic-panel
    cosmic-store
    cosmic-applets
    cosmic-ext-ctl
    cosmic-session
    cosmic-launcher
    cosmic-settings
    cosmic-protocols
    cosmic-applibrary
    cosmic-ext-tweaks
    cosmic-screenshot
    cosmic-notifications
    cosmic-settings-daemon
    cosmic-workspaces-epoch
    pop-icon-theme
    pop-launcher
    xdg-user-dirs
    xwayland
  ];
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
