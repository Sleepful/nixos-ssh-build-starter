{ pkgs, modulesPath, ... }:
{
  environment.systemPackages = [
    pkgs.tree
  ];
}
