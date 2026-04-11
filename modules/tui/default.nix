{
  den,
  inputs,
  __findFile,
  ...
}:
{
  den.aspects.tui = {
    includes = [
      <tui/fzf>
      <tui/nvim>
      <tui/tmux>
      <tui/nh>
      <tui/yazi>
      <tui/ai>
    ];
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          sqlit-tui
          powertop
        ];
      };
  };
}
