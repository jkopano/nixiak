{
  pkgs,
  config,
  lib,
  ...
}:
{
  startup = [
    {
      command = "systemctl restart --user xremap.service";
      always = true;
      notification = false;
    }
    {
      command = "${pkgs.autorandr}/bin/autorandr -c";
      always = false;
      notification = false;
    }

    # Clipboard manager
    {
      command = "${pkgs.clipmenu}/bin/clipmenud";
      always = false;
      notification = false;
    }

    # Welcome notification
    {
      command = "sleep 10; ${pkgs.dunst}/bin/dunstify \"Hello, i3 :)))\" \"Have a nice day OwO\" --icon ${config.xdg.configHome}/dunst/icons/Pingwinek.png";
      always = false;
      notification = false;
    }

    # KeePassXC
    {
      command = "sleep 5; ${pkgs.keepassxc}/bin/keepassxc-dmenu";
      always = false;
      notification = false;
    }

    # Keyd-mapper
    # {
    #   command = "sleep 3; ${pkgs.keepassxc}/keyd-application-mapper -d";
    #   always = false;
    #   notification = false;
    # }

    # Keyboard settings
    {
      command = "sleep 5 && ${lib.getExe pkgs.xorg.xset} r rate 200 40";
      always = true;
      notification = false;
    }

    # Network manager
    # {
    #   command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
    #   always = false;
    #   notification = false;
    # }

    # Window switcher
    {
      command = "${lib.getExe pkgs.killall} -q i3-auto-layout; ${pkgs.i3-auto-layout}/bin/i3-auto-layout";
      always = true;
      notification = false;
    }

    {
      command = "${lib.getExe pkgs.killall} -SIGUSR1 i3status-rust";
      always = true;
      notification = false;
    }
    {
      command = "${pkgs.feh}/bin/feh --bg-fill ${config.xdg.configHome}/.wal.jpg";
      always = true;
      notification = false;
    }
  ];
}
