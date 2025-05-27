{ pkgs, config, lib, ... }: let 
  inject = builtins.fetchurl {
    url = https://raw.githubusercontent.com/MrTipson/DiscordCSS/835cf516d4b8d8fbbfaf081c0a65927ba56b848a/inject;
    sha256 = "sha256:1lajf7h8xyhrj0zpsqhcq88xcqf5hs80cyqk3rm7vdrsqdghhgjv";
  };
  style = builtins.toFile "discord-custom.css" (with config.lib.stylix.colors.withHashtag; /*css*/ ''
    @import url("https://mrtipson.github.io/DiscordCSS/css/base.css");
    @import url("https://mrtipson.github.io/DiscordCSS/css/base16.css");
    @import url("https://mrtipson.github.io/DiscordCSS/css/server-bar.css");
    @import url("https://mrtipson.github.io/DiscordCSS/css/server-folders.css");
    @import url("https://mrtipson.github.io/DiscordCSS/css/channel-sidebar-utils.css");
    @import url("https://mrtipson.github.io/DiscordCSS/css/candy-land.css");

    .theme-light.theme-light, .theme-dark.theme-dark {
      --base00: ${base00}fe;
      --base01: ${base01}fe;
      --base02: ${base02}fe;
      --base03: ${base03}fe;
      --base04: ${base04}fe;
      --base05: ${base05}fe;
      --base06: ${base06}fe;
      --base07: ${base07}fe;
      --base08: ${base08}fe;
      --base09: ${base09}fe;
      --base0A: ${base0A}fe;
      --base0B: ${base0B}fe;
      --base0C: ${base0C}fe;
      --base0D: ${base0D}fe;
      --base0E: ${base0E}fe;
      --base0F: ${base0F}fe;

      --color-main: rgb(68, 152, 255);
      --window-opacity: ${builtins.toString config.stylix.opacity.applications};
    }
  '');
in 
{
  home.packages = [ pkgs.discord ];

  home.activation.activateDiscord = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run cat ${inject} | sh -s -- -c "${style}" -t
  '';
}
