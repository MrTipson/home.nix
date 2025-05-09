{ pkgs, config, inputs, ... }:
{
  stylix.targets.firefox.profileNames = [ "default" ];
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    profiles.default = {
      search = {
        default = "ddg";
        privateDefault = "ddg";
        force = true;
      };
      settings = {
        "sidebar.verticalTabs" = true;
        "browser.urlbar.suggest.recentsearches" = false;
      };
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        bitwarden
      ];
      # browser toolbox - enable in devtools settings
      userChrome = ''
        #unified-extensions-button { display: none; }
        moz-button[view="viewCustomizeSidebar"] { display: none !important; }
        #sidebar-main { padding-bottom: 5px; }
      '';
    };
  };
}
