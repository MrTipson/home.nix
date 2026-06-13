{
  sources,
  pkgs,
  lib,
  myconfig,
  ...
}:
{
  imports =
    with import ./modules lib;
    [
      terminal.fish
      terminal.fzf

      ssh.github
      ssh.minipc
      ssh.rpi
    ]
    ++ lib.optionals myconfig.graphical (
      with graphical;
      [
        specialisation
        discord
        firefox
        obs-studio
        pipewire
        spotify
        stylix-qt
        stylix
        vr
        vscode
      ]
    );
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
    store.cleanup = true;
  };
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tipson";
  home.homeDirectory = "/home/tipson";
  xdg.userDirs.setSessionVariables = true;

  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      comma
      tldr
      zenith-nvidia # hardware monitor
    ]
    ++ lib.optionals myconfig.graphical [
      mangohud # hardware overlay
      mpv
      ffmpeg
      xdg-utils
    ];

  programs.nix-index.enable = true; # nix-locate
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.git = {
    enable = true;
    settings.user = {
      name = "MrTipson";
      email = "mr@tipson.xyz";
    };
    signing.format = null;
  };

  programs.ssh.enableDefaultConfig = false;
  programs.ssh.settings."*" = {
    forwardAgent = false;
    addKeysToAgent = "no";
    compression = false;
    serverAliveInterval = 0;
    serverAliveCountMax = 3;
    hashKnownHosts = false;
    userKnownHostsFile = "~/.ssh/known_hosts";
    controlMaster = "no";
    controlPath = "~/.ssh/master-%r@%n:%p";
    controlPersist = "no";
  };

  home.file = {
    ".sops.yaml".text = ''
      keys:
        - &mrtipson age1lp6w8qkkzcuvgz6md0wjc98e60nky3exme7uaz232mza7vqts95q824yeg
      creation_rules:
        - path_regex: secrets/[^/]+\.(yaml|json|env|ini)$
          key_groups:
          - age:
            - *mrtipson
    '';
    ".profile".text = "exec ${lib.getExe pkgs.fish} -l";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
