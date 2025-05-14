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
        llvm-vs-code-extensions.vscode-clangd
        # denoland.vscode-deno
        # manually: https://open-vsx.org/extension/jeanp413/open-remote-ssh
      ];
      userSettings = {
        "clangd.path" = "${pkgs.llvmPackages_19.clang-tools}/bin/clangd";
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
