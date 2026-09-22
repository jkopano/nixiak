{ den, lib, ... }:
{
  den.aspects.gui._.terminal.homeManager =
    { pkgs, ... }:
    let
      footDefaultKeybinds = [
        "scrollback-up-page"
        "scrollback-down-page"

        "clipboard-copy"
        "clipboard-paste"
        "primary-paste"

        "search-start"

        "font-increase"
        "font-decrease"
        "font-reset"

        "spawn-terminal"
        "show-urls-launch"

        "prompt-prev"
        "prompt-next"

        "unicode-input"
      ];
    in
    {
      home.packages = [
        pkgs.st
      ];

      programs = {
        kitty = {
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

        ghostty = {
          enable = true;
          clearDefaultKeybinds = true;

          settings = {
            font-size = 14;

            keybind = [
              "all:ctrl+enter=text:\\x1b[13;5u"

              "alt+c=copy_to_clipboard"
              "alt+v=paste_from_clipboard"

              "ctrl+shift+equal=increase_font_size:2"
              "ctrl+shift+minus=decrease_font_size:2"
            ];

            confirm-close-surface = false;

            window-padding-x = 2;
            window-padding-y = 2;

            window-decoration = "none";
          };
        };

        foot = {
          enable = true;

          settings = {
            main = {
              # Ctrl+Shift+= / - zmienia rozmiar o 2 pt
              font-size-adjustment = 2;

              pad = "2x2";
            };

            csd = {
              preferred = "none";
            };

            key-bindings = lib.genAttrs footDefaultKeybinds (_: "none") // {
              clipboard-copy = "Alt+c";
              clipboard-paste = "Alt+v";

              font-increase = "Control+Shift+equal";
              font-decrease = "Control+Shift+minus";
            };

            text-bindings = {
              "\\x1b[13;5u" = "Control+Return";
            };
          };
        };
      };
    };
}
