{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      keybindings = [
        {
          key = "alt+s";
          command = "workbench.action.files.saveWithoutFormatting";
          when = "textInputFocus";
        }
        {
          key = "ctrl+t";
          command = "workbench.action.terminal.focus";
        }
        {
          key = "ctrl+t";
          command = "workbench.action.focusActiveEditorGroup";
          when = "terminalFocus";
        }
      ];
      extensions = with pkgs.vscode-extensions; [
        golang.go
        jnoortheen.nix-ide
        bradlc.vscode-tailwindcss
        ms-vscode.live-server
        llvm-vs-code-extensions.vscode-clangd
        ms-python.python
        # denoland.vscode-deno
        # manually: https://open-vsx.org/extension/jeanp413/open-remote-ssh
      ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "nix.serverSettings.nil.formatting.command" = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
        "clangd.path" = "${pkgs.clang-tools}/bin/clangd"; # cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .
        "remote.SSH.connectTimeout" = 120;
        "remote.SSH.useLocalServer" = false;
        "terminal.integrated.inheritEnv" = false;
        "files.associations" = {
          "*.css" = "tailwindcss";
        };
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.formatOnSave" = true;
        "chat.disableAIFeatures" = true;
        "workbench.secondarySideBar.defaultVisibility" = "hidden";
      };
    };
  };
}
