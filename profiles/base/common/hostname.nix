{ lib, ... }:
{
  networking.hostName = lib.mkDefault null;
}
