# Android development environment
{ den, ... }:
{
  den.aspects.gui._.android.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        android-studio
      ];
    };
}
