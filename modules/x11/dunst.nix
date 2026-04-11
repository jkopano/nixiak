# Dunst notification daemon
{ den, ... }:
{
  den.aspects.x11._.dunst.homeManager =
    { ... }:
    {
      services.dunst = {
        enable = true;
        settings = {
          global = {
            monitor = 0;
            follow = "mouse";
            width = "(200, 400)";
            height = "(150, 400)";
            origin = "top-right";
            offset = "(22,62)";
            scale = 0;
            notification_limit = 0;
            progress_bar = true;
            progress_bar_height = 10;
            progress_bar_frame_width = 2;
            progress_bar_min_width = 125;
            progress_bar_max_width = 250;
            progress_bar_corner_radius = 5;
            indicate_hidden = "yes";
            transparency = 8;
            separator_height = 0;
            padding = 15;
            horizontal_padding = 15;
            text_icon_padding = 0;
            frame_width = 2;
            sort = "no";
            idle_threshold = 0;
            line_height = 0;
            markup = "full";
            format = "<span size='xx-large' font_desc='Hurmit Nerd Font 9' weight='bold' foreground='#8aadf4'>%s</span>\n%b";
            alignment = "center";
            vertical_alignment = "center";
            show_age_threshold = 20;
            ignore_newline = "no";
            stack_duplicates = false;
            hide_duplicate_count = true;
            show_indicators = "yes";
            icon_position = "left";
            icon_size = 48;
            max_icon_size = 72;
            icon_folders = ''"Papirus-Dark", "breeze-dark"'';
            shrink = "yes";
            sticky_history = "yes";
            history_length = 20;
            dmenu = "/usr/bin/dmenu -i dunst:";
            browser = "/usr/bin/xdg-open";
            always_run_script = true;
            title = "Dunst";
            class = "Dunst";
            corner_radius = 0;
            gap_size = 4;
            mouse_left_click = "close_current";
            mouse_middle_click = "close_all";
            mouse_right_click = "do_action, close_current";
            ignore_dbusclose = false;
          };

          urgency_low = {
            timeout = 3;
          };

          urgency_normal = {
            timeout = 5;
          };

          urgency_critical = {
            timeout = 0;
          };
        };
      };
    };
}
