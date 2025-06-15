{ inputs, config, pkgs, lib, myconfig, ... }: {
  imports = with import ./modules; [
    terminal.fish
    terminal.television

    ssh.github
    ssh.minipc
    ssh.rpi
  ] ++ lib.optionals myconfig.graphical (with graphical; [
    discord
    firefox
    mpv
    obs-studio
    pipewire
    spotify
    stylix-qt
    stylix
    vscode
  ]);
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
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    zenith-nvidia # hardware monitor
    tldr
  ] ++ lib.optionals myconfig.graphical [
    mangohud # hardware overlay
    ffmpeg
    xdg-utils
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.git = {
    enable = true;
    userName = "MrTipson";
    userEmail = "mr@tipson.xyz";
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

  programs.fish.loginShellInit = ''
    set selected (${pkgs.gum}/bin/gum choose (ls ~/specialisation))

    if test -n "$selected"
      ~/specialisation/"$selected"/activate
      source ~/session.start
    end
  '';
  specialisation = import ./specializations;

  home.activation."specialisationSetup" = ''
    if [[ -e $newGenPath/specialisation ]]; then
      test -h specialisation && unlink specialisation
      ln -s $newGenPath/specialisation
    fi
  '';

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
