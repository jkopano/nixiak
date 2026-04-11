{ den, ... }:
{
  den.aspects.services._.rclone.homeManager =
    { config, pkgs, lib, ... }:
    let
      sftp = "${config.xdg.dataHome}/srv/sftp";
    in
    {
      programs.rclone = {
        enable = true;
        remotes = {
          sftp = {
            config = {
              type = "sftp";
              host = "kopan-alpine";
              user = "sftpuser";
              shell_type = "unix";
            };
            mounts = {
              "/srv/sftpuser/data/" = {
                enable = true;
                mountPoint = sftp;
                options = {
                  "vfs-cache-mode" = "minimal";
                  "daemon-wait" = "240s";
                };
              };
            };
          };
        };
      };
    };
}
