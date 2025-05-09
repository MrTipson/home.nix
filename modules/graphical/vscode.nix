{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        golang.go
        jnoortheen.nix-ide
        bradlc.vscode-tailwindcss
        ms-vscode.live-server
        # llvm-vs-code-extension
        # ons.vscode-clangd
        # denoland.vscode-deno
        # manually: https://open-vsx.org/extension/jeanp413/open-remote-ssh
      ];
      userSettings = {
        "remote.SSH.connectTimeout" = 120;
        "remote.SSH.useLocalServer" = false;
        "terminal.integrated.inheritEnv" = false;
        "files.associations" = {
          "*.css" = "tailwindcss";
        };
      };
    };
  };
}
