{ pkgs, inputs, ... }:
let
  aspect = path: (import path { inherit inputs; den = null; __findFile = null; }).den.aspects;
in
{
  programs.zsh.enable = true;
  users.users.kuba.shell = pkgs.zsh;
  environment.variables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
  };

  environment.systemPackages = with pkgs; [
    bat
    curl
    devenv
    fd
    fzf
    gcc
    git
    htop
    imagemagick
    jq
    lazygit
    neovim
    ripgrep
    unzip
    wget
  ];

  services.openssh = {
    enable = true;
    ports = [ 2223 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  networking.firewall.allowedTCPPorts = [ 2223 ];
  users.users.kuba.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBO7rMMozgaDSFkDV+eQVWb/iG6Z2P3vPFGlBNQKvWAa kuba@kuba-laptop"
  ];
  security.sudo.extraRules = [
    {
      users = [ "kuba" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.kuba = { config, lib, ... }: {
      imports = [
        (aspect ../../modules/cli/default.nix).cli.homeManager
        (aspect ../../modules/cli/zsh/default.nix).cli._.zsh.homeManager
        (aspect ../../modules/cli/starship.nix).cli._.starship.homeManager
        (aspect ../../modules/tui/fzf.nix).tui._.fzf.homeManager
        (aspect ../../modules/tui/tmux/sesh.nix).tui._.tmux._.sesh.homeManager
        (aspect ../../modules/tui/tmux/default.nix).tui._.tmux.homeManager
        (aspect ../../modules/tui/yazi/default.nix).tui._.yazi.homeManager
        (aspect ../../modules/tui/nh.nix).tui._.nh.homeManager
        (aspect ../../modules/services/git.nix).services._.git.homeManager
      ];
      programs.direnv.stdlib = ''
        eval "$(${pkgs.devenv}/bin/devenv direnvrc)"
      '';
      programs.fzf.historyWidget.zsh.command = "";
      # The repository currently tracks laptop-specific store symlinks at these
      # paths. Replace them with WSL-owned Home Manager files after cloning.
      home.file = {
        ".config/nixos/modules/tui/nvim/spell/pl.utf-8.spl" = {
          force = true;
          source = builtins.fetchurl {
            url = "https://ftp.uni-bayreuth.de/packages/editors/vim/runtime/spell/pl.utf-8.spl";
            sha256 = "sha256:1sg7hnjkvhilvh0sidjw5ciih0vdia9vas8vfrd9vxnk9ij51khl";
          };
        };
        ".config/nixos/modules/tui/nvim/lua/plugins/editor/ui/colorscheme.lua" = {
          force = true;
          text = ''
            return {
              { "LazyVim/LazyVim", opts = function(_, opts)
                opts.colorscheme = "catppuccin-mocha"
              end },
              { "catppuccin/nvim", opts = function(_, opts)
                opts.color_overrides = { all = { base = "#131313", mantle = "#1d2021" } }
                return opts
              end },
              { "sainnhe/gruvbox-material" },
            }
          '';
        };
      };
      home = {
        username = "kuba";
        homeDirectory = "/home/kuba";
        stateVersion = "25.05";
        shellAliases.n = "nvim";
        file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/kuba/.config/nixos/modules/tui/nvim";
      };
      programs.tmux.extraConfig = lib.mkAfter ''
        bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "clip.exe"
        bind-key -T copy-mode-vi MouseDragEnd1Pane send -X copy-pipe-and-cancel "clip.exe"
      '';
    };
  };
}
