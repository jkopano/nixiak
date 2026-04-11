{ den, ... }:
{
  den.aspects.tui._.fzf.homeManager =
    { lib, pkgs, ... }:
    let
      options = [
        "--bind 'ctrl-l:accept'"
        "--layout=reverse"
      ];
    in
    {
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        tmux = {
          enableShellIntegration = true;
        };
        defaultOptions = lib.mkForce options;
      };
      home.packages = [
        pkgs.fzf
      ];
    };
}
