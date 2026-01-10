{ myconfig, config, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      github = {
        host = "github.com";
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github";
      };
    };
  };

  home.file."key-github" = {
    enable = myconfig.impermanence;
    source = "${config.home.homeDirectory}/Extra/github";
    target = "${config.home.homeDirectory}/.ssh/github";
  };
}
