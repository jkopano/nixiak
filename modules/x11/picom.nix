# Picom compositor
{ den, ... }:
{
  den.aspects.x11._.picom.homeManager =
    { ... }:
    {
      services.picom = {
        enable = true;
        backend = "glx";
        extraArgs = [
          "--glx-no-stencil"
        ];
        shadow = true;
        fade = true;
        fadeDelta = 4;
        shadowOffsets = [
          (-9)
          (-9)
        ];
        shadowOpacity = 0.95;
        shadowExclude = [
          "class_g = 'Rofi'"
          "class_g = 'dmenu'"
          "_NET_WM_WINDOW_TYPE@:a = 'MENU'"
          "_NET_WM_WINDOW_TYPE@:a = 'DROPDOWN_MENU'"
          "_NET_WM_WINDOW_TYPE@:a = 'POPUP_MENU'"
          "_NET_WM_WINDOW_TYPE@:a = 'TOOLTIP'"
          "name = 'Notification'"
          "class_g = 'firefox' && (window_type = 'dropdown_menu' || window_type = 'popup_menu' || window_type = 'tooltip')"
          "_NET_WM_WINDOW_TYPE@:a = '_NET_WM_WINDOW_TYPE_COMBO'"
          "_NET_WM_WINDOW_TYPE@:a = '_NET_WM_WINDOW_TYPE_NOTIFICATION'"
          "name = 'Popup'"
        ];

        settings = {
          corner-radius = 5;

          rounded-corners-exclude = [
            "window_type = 'dock'"
            "window_type = 'dropdown_menu'"
            "window_type = 'popup_menu'"
            "window_type = 'tooltip'"
          ];
        };

        wintypes = {
          menu = {
            shadow = false;
          };
          dropdown_menu = {
            shadow = false;
          };
          popup_menu = {
            shadow = false;
          };
          tooltip = {
            shadow = false;
          };
          dock = {
            shadow = true;
          };
          dnd = {
            shadow = false;
          };
        };
      };
    };
}
