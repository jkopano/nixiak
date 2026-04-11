# Fish shell configuration
{ den, ... }:
{
  den.aspects.cli._.fish.homeManager =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        plugins = [
          {
            name = "fasd";
            src = pkgs.fetchFromGitHub {
              owner = "PatrickF1";
              repo = "fzf.fish";
              rev = "8920367";
              sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
            };
          }
        ];
      };
    };
}
