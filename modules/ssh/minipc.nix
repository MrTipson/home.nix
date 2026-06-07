{ ... }:
{
  programs.ssh = {
    enable = true;
    settings = {
      minipc = {
        host = "minipc";
        hostname = "nospit.local";
      };
    };
  };
}
