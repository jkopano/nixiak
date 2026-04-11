{ den, ... }:
{
  den.aspects.cli._.nushell.homeManager =
    { ... }:
    {
      programs.nushell = {
        enable = true;
      };
    };
}
