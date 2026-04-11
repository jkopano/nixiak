{ den, ... }:
{
  den.aspects.services._.torrents.nixos = _: {
    services.jackett.enable = true;
    services.flaresolverr.enable = true;
  };
}
