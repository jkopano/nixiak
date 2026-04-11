{ den, inputs, __findFile, ... }:
{
  den.aspects.session = {
    includes = [ ];
    nixos =
      { pkgs, config, lib, ... }:
      {
        environment.sessionVariables = rec {
          XDG_CACHE_HOME = "$HOME/.cache";
          XDG_CONFIG_HOME = "$HOME/.config";
          XDG_DATA_HOME = "$HOME/.local/share";
          XDG_STATE_HOME = "$HOME/.local/state";
          XDG_BIN_HOME = "$HOME/.local/bin";
          PATH = [ "${XDG_BIN_HOME}" ];
          NIXOS_CONFIG = config.var.configDir;
          SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
        };

        console.keyMap = "pl2";
        services = {
          displayManager = {
            gdm.enable = true;
          };
          gnome = {
            gnome-keyring.enable = lib.mkForce false;
            gcr-ssh-agent.enable = lib.mkForce false;
          };
          gvfs.enable = true;
        };

        environment.systemPackages = [ pkgs.libsecret ];
        security.polkit = {
          enable = true;
        };
      };
  };
}
