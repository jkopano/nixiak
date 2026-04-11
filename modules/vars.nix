{ den, ... }:
let
  sharedModule =
    { lib, config, ... }:
    {
      options = {
        var = lib.mkOption {
          type = lib.types.attrs;
          default = { };
        };
      };

      config.var = rec {
        username = "kuba";
        isLaptop = true;
        wayland = true;
        configDir = "/home/${username}/.config/nixos";
        keyboardLayout = "pl";
        location = "Warsaw";
        timeZone = "Europe/Warsaw";
        defaultLocale = "en_US.UTF-8";
        extraLocale = "pl_PL.UTF-8";

        # SFTP/Keys path
        sftp = "/home/${username}/.local/share/srv/sftp";

        stylix = "catppuccin-mocha";

        KEEPASSXCDT = "${sftp}/.keys/Passwords.kdbx";
        KEEPASSXCFILE = "${sftp}/.keys/keys";

        git = {
          inherit username;
          email = "jakub.kopaniewski@protonmail.com";
        };

        autoUpgrade = false;
        autoGarbageCollector = true;

        pwa = {
          twitter = "01K07PG97YZPHRRPZ8MMSTJGD0";
          messenger = "01K07PG97YYJ8XJJAW2FRR7WRB";
          reddit = "01K07QPRC20VRMPN2T8G1DHYPB";
        };
      };
    };
in
{
  den.aspects.vars = {
    nixos = {
      imports = [
        {
          key = "vars-module-dedup";
          imports = [ sharedModule ];
        }
      ];
    };
    homeManager = {
      imports = [
        {
          key = "vars-module-dedup";
          imports = [ sharedModule ];
        }
      ];
    };
  };
}
