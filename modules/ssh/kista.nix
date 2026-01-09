{ ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      kista = {
        host = "kista";
        hostname = "kista.local";
      };
    };
  };
}
