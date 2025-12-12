{
  pkgs,
  lib,
  myconfig,
  ...
}:
{
  imports =
    with import ./modules;
    [
      terminal.fish
      terminal.specialisation
      terminal.television

      ssh.github
      ssh.minipc
      ssh.rpi
    ]
    ++ lib.optionals myconfig.graphical (
      with graphical;
      [
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

  nixpkgs.config.allowUnfree = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      zenith-nvidia # hardware monitor
      tldr
    ]
    ++ lib.optionals myconfig.graphical [
      mangohud # hardware overlay
      mpv
      ffmpeg
      xdg-utils
    ];

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
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
  };

  programs.ssh.enableDefaultConfig = false;
  programs.ssh.matchBlocks."*" = {
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
