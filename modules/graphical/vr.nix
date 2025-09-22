# in case something crashes and steamvr is acting up, check if another server is still running `ps -aux | grep vrserver`
{ pkgs, config, ... }:
{
  xdg.configFile."openxr/1/active_runtime.json".text = ''
    {
      "file_format_version" : "1.0.0",
      "runtime" : {
        "VALVE_runtime_is_steamvr" : true,
        "library_path" : "${config.xdg.dataHome}/Steam/steamapps/common/SteamVR/bin/linux64/vrclient.so",
        "name" : "SteamVR"
      }
    }
  '';

  home.packages = with pkgs; [
    alvr
  ];
}
