{ ... }:
{
  programs.ssh = {
    enable = true;
    settings = {
      kista = {
        host = "kista";
        hostname = "kista.local";
      };
    };
  };
}
