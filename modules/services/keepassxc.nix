{ den, ... }:
{
  den.aspects.services._.keepassxc.homeManager =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      sftp = "${config.xdg.dataHome}/srv/sftp";
      KEEPASSXCDT = "${sftp}/.keys/Passwords.kdbx";
      KEEPASSXCFILE = "${sftp}/.keys/keys";
    in
    {
      services.gnome-keyring.enable = lib.mkForce false;

      # xdg.autostart.enable = true;

      programs.keepassxc = {
        enable = true;
        autostart = false;
        # autostart = true;
      };

      home = {
        sessionVariables = {
          "KEEPASSXCDT" = KEEPASSXCDT;
          "KEEPASSXCFILE" = KEEPASSXCFILE;
        };

        packages = with pkgs; [
          keepmenu
        ];

        file.".config/keepmenu/config.ini".text = ''
          [dmenu]
          dmenu_command = ${lib.getExe pkgs.rofi} -dmenu -i -theme keepmenu -f "JetbrainsMono Nerd Font 18"

          [dmenu_passphrase]
          obscure = True
          obscure_color = #222222

          [database]
          database_1 = ${KEEPASSXCDT}
          keyfile_1 = ${KEEPASSXCFILE}
          pw_cache_period_min = 360
          autotype_default = {USERNAME}{TAB}{PASSWORD}{ENTER}
        '';
      };

      systemd.user.services.keepassxc-autostart = {
        Unit = {
          Description = "Keepassxc";
          After = [
            "graphical-session-pre.target"
            "rclone-mount:.srv.sftpuser.data.@sftp.service"
          ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.keepassxc}/bin/keepassxc --keyfile ${KEEPASSXCFILE} ${KEEPASSXCDT}";
          Restart = "on-failure";
          RestartSec = "10s";
        };
      };
    };
}
