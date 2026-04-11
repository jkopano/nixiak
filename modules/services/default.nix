{ den, __findFile, ... }:
{
  den.aspects.services = {
    includes = [
      <services/docker>
      <services/git>
      <services/keepassxc>
      <services/mime>
      <services/rclone>
      <services/ssh>
      <services/systemd>
      <services/tailscale>
      <services/torrents>
    ];
  };
}
