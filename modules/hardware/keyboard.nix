{ den, ... }:
{
  den.aspects.hardware._.keyboard.nixos =
    { pkgs, lib, ... }:
    {
      services = {
        xserver = {
          xkb = {
            layout = "pl";
            variant = "";
          };
          autoRepeatDelay = 180;
          autoRepeatInterval = 60;
        };
        xremap = {
          enable = true;
          watch = true;
          withX11 = false;
          withNiri = true;
          serviceMode = "user";
          userName = "kuba";
          config = {
            modmap = [
              {
                name = "Global";
                remap = {
                  "CapsLock" = "Control_L";
                };
                remap = {
                  "102ND" = "Shift_L";
                };
              }
            ];
            keymap = [
              {
                name = "Example ctrl-u > pageup rebind, only for specific application";
                remap = {
                  "ALT_L-k" = "C-Shift-Tab";
                  "ALT_L-j" = "C-Tab";
                  "ALT_L-h" = "ALT-left";
                  "ALT_L-l" = "ALT-right";
                  "ALT_L-c" = "ALT-Shift-d";
                  "ALT-Shift-k" = "C-Shift-PAGEUP";
                  "ALT-Shift-j" = "C-Shift-PAGEDOWN";
                  "ALT-u" = "C-Shift-t";
                  "ALT-d" = "C-w";
                  "ALT_L-o" = "C-t";
                  "C-e" = "C-M-z";
                };
                application.only = [ "firefox" ];
              }
              {
                remap = {
                  "ALT_L-Esc" = "Shift-KEY_GRAVE";
                  "Shift-Esc" = "Shift-KEY_GRAVE";
                  "ALT_R-KEY_BACKSLASH" = "KEY_GRAVE";
                };
              }
            ];
          };
        };
      };

      services.udev.extraRules = ''
        KERNEL=="uinput", GROUP="input", TAG+="uaccess"
      '';
    };
}
