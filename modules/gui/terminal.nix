{ den, ... }:
{
  den.aspects.gui._.terminal.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.st
      ];

      programs.kitty = {
        enable = true;
        keybindings = {
          "ctrl+enter" = "send_text all \\x1b[13;5u";
          "alt+c" = "copy_to_clipboard";
          "alt+v" = "paste_from_clipboard";
          "ctrl+shift+equal" = "change_font_size all +2.0";
          "ctrl+shift+minus" = "change_font_size all -2.0";
        };
        settings = {
          font_size = 14;
          cursor_trail = 1;
          cursor_trail_decay = "0.1 0.2";
          clear_all_shortcuts = "yes";
          confirm_os_window_close = 0;
          window_margin_width = 2;
          hide_window_decorations = "yes";
        };
      };
    };
}
