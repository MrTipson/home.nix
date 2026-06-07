{ ... }:
{
  programs.ssh = {
    enable = true;
    settings = {
      rpi = {
        host = "rpi";
        hostname = "192.168.64.229";
        port = 299;
        user = "tipsi";
      };
    };
  };
}
