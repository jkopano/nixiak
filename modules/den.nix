{
  inputs,
  den,
  ...
}:
{
  _module.args.__findFile = den.lib.__findFile;
  systems = builtins.attrNames den.hosts;
  imports = [ inputs.den.flakeModule ];

  den.hosts.x86_64-linux.jkopano.users.kuba = {
    aspects = [ "kuba" ];
    classes = [ "homeManager" ];
  };
}
