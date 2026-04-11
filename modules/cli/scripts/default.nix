{ den, ... }:
{
  den.aspects.cli._.scripts.homeManager =
    { lib, pkgs, config, ... }:
    {
      home.packages = [
        (import ./_fzf-session.nix { inherit config pkgs; })
        (import ./_media-control.nix { inherit lib config pkgs; })
        (import ./_brightness.nix { inherit config pkgs; })
        (import ./_brightness-control.nix { inherit pkgs; })
        (import ./_i3-scratchpad.nix { inherit config lib pkgs; })
        (import ./_keepassxc-dmenu.nix { inherit lib config pkgs; })
        (import ./_nvim-godot.nix { inherit pkgs; })
      ];
    };
}
