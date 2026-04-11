{ den, ... }:
{
  den.aspects.services._.docker.nixos =
    { ... }:
    {
      virtualisation.docker.enable = true;
      users.users.kuba.extraGroups = [ "docker" ];
    };
}
