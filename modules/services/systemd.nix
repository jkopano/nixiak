{ den, ... }:
{
  den.aspects.services._.systemd.homeManager =
    { ... }:
    {
      systemd.user.startServices = true;
    };
}
