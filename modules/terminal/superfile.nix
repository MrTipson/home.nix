# Stopped using this as file modification times (among other things) are not preserved
{ pkgs, ... }:
{
  home.packages = [ pkgs.superfile ];
}
