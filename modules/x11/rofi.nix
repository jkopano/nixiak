# Rofi application launcher
{ den, ... }:
{
  den.aspects.x11._.rofi.homeManager =
    { config, lib, ... }:
    let
      inherit (config.lib.formats.rasi) mkLiteral;
      base = {
        selected-normal-foreground = lib.mkDefault (mkLiteral "@foreground");
        normal-foreground = lib.mkForce (mkLiteral "@foreground");
        alternate-normal-background = lib.mkForce (mkLiteral "@background");
        selected-urgent-foreground = lib.mkForce (mkLiteral "@foreground");
        urgent-foreground = lib.mkForce (mkLiteral "@foreground");
        alternate-urgent-background = lib.mkForce (mkLiteral "@background");
        active-foreground = lib.mkForce (mkLiteral "@foreground");
        selected-active-foreground = lib.mkForce (mkLiteral "@foreground");
        alternate-normal-foreground = lib.mkForce (mkLiteral "@foreground");
      };
    in
    {
      programs.rofi = {
        enable = true;
        font = lib.mkDefault "JetBrainsMono Nerd Font 18";
        extraConfig = {
          show-icons = true;
          modes = [
            "run"
            "drun"
            "window"
          ];
          drun-match-fields = [
            "name"
            "generic"
            "exec"
          ];
          drun-display-format = "{icon} {name}";
          display-drun = " Apps";
          display-run = "   Run";
          display-window = " 󰕰  Window";
          display-Network = " 󰤨  Network";
          kb-accept-entry = "Control+m,Return,KP_Enter";
          kb-remove-to-eol = "";
          kb-row-up = "Control+k";
          kb-row-down = "Control+j";
        };

        theme = {
          "*" = {
            width = mkLiteral "800px";
          }
          // base;
          "keepmenu" = {
            width = mkLiteral "500px";
          }
          // base;

          configuration = {
            modi = "drun";
            show-icons = true;
            fixed-num-lines = false;
            fixed-width = false;
          };

          window = lib.mkForce {
            transparency = "screenshot";
            location = mkLiteral "north";
            anchor = mkLiteral "north";
            fullscreen = false;
            width = "800px";
            height = "600px";
            "x-offset" = mkLiteral "0px";
            "y-offset" = mkLiteral "36px";
            border = mkLiteral "3px solid";
            "border-color" = "@background-alt";
          };

          mainbox = {
            children = map mkLiteral [
              "inputbar"
              "listview"
            ];
          };

          inputbar = {
            padding = mkLiteral "15px";
            children = map mkLiteral [
              "prompt"
              "entry"
            ];
          };

          textbox-prompt-colon = {
            margin = mkLiteral "0px 0.3000em 0.0000em 0.0000em";
            expand = false;
            str = "::";
            text-color = mkLiteral "inherit";
          };

          listview = {
            lines = 14;
            columns = 1;
            spacing = mkLiteral "5px";
          };

          element = {
            spacing = mkLiteral "20px";
            padding = mkLiteral "8px";
            background-color = mkLiteral "@background";
            text-align = mkLiteral "center";
          };

          element-text = {
            horizontal-align = mkLiteral "0.5";
          };

          "element normal.normal" = lib.mkForce {
            "background-color" = mkLiteral "@background";
            "text-color" = mkLiteral "@foreground";
          };
        };
      };
    };
}
