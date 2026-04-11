# Wallpaper configuration
{ den, inputs, ... }:
{
  den.aspects.x11._.wal.homeManager =
    { pkgs, config, ... }:
    {
      home.packages = [ pkgs.feh ];
      home.file."${config.xdg.configHome}/.wal.jpg".source = "${inputs.self.outPath}/res/" + "wal.jpg";
    };
}
