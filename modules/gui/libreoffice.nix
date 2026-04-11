{ den, ... }:
{
  den.aspects.gui._.libreoffice.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        libreoffice-qt6
        hunspell
        hunspellDicts.pl_PL
      ];
    };
}
