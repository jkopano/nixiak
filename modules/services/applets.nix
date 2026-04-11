# Applets service module
{ den, ... }:
{
  den.aspects.services._.applets.homeManager =
    { ... }:
    {
      services = {
        blueman-applet.enable = false;
        pasystray.enable = true;
        network-manager-applet.enable = true;
      };
    };
}
