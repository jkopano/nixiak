{ den, ... }:
{
  den.aspects.tui._.yazi.homeManager =
    { pkgs, ... }:
    let
      lib = pkgs.lib;
      mkForceRecursive =
        attrs:
        lib.mapAttrsRecursive (_path: value: lib.mkForce value) attrs;
      settings = import ./_yazi.nix { inherit pkgs; };
      keymap = import ./_keymaps.nix;
      theme = mkForceRecursive (import ./_theme.nix);
    in
    {
      home.packages = with pkgs; [
        ueberzugpp
        rich-cli
      ];
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
        shellWrapperName = "rs";
        inherit settings keymap theme;
        plugins = with pkgs.yaziPlugins; {
          inherit
            lazygit
            git
            smart-enter
            smart-filter
            starship
            rich-preview
            piper
            chmod
            relative-motions
            wl-clipboard
            ;
        };

        initLua = # lua
          ''
            require("git"):setup()
            require("smart-enter"):setup {
                     open_multi = true,
                   }
            require("starship"):setup()
            require("session"):setup {
              sync_yanked = true
            }

            require("relative-motions"):setup({
              show_numbers="relative",
              show_motion = true,
              enter_mode ="first"
            })
          '';
      };
    };
}
