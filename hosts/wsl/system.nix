{ pkgs, ... }:
{
  programs.zsh.enable = true;
  users.users.kuba.shell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    bat
    curl
    fd
    fzf
    git
    htop
    jq
    lazygit
    neovim
    ripgrep
    tmux
    unzip
    wget
    zoxide
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
    users.kuba = { config, ... }: {
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
        file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/kuba/.config/nixos/modules/tui/nvim";
      };
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases.n = "nvim";
      };
      programs.tmux = {
        enable = true;
        mouse = true;
        terminal = "tmux-256color";
      };
    };
  };
}
