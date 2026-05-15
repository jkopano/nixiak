{ den, ... }:
{
  den.aspects.cli._.zsh.homeManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      configDir = "/home/kuba/.config/nixos";
    in
    {
      home = {
        packages = with pkgs; [
          bat
          ncdu
          sd
          grc
          tldr
        ];
        file.".config/atuin/config.toml".text = ''
          auto_sync = true
          sync_frequency = "5m"
          sync_address = "https://api.atuin.sh"
          search_mode = "fuzzy"
          ctrl_n_shortcuts = true

          [keymap.emacs]
          "alt-j" = "select-next"
          "alt-k" = "select-previous"
          "ctrl-j" = "select-next"
          "ctrl-k" = "select-previous"
        '';
        shellAliases = {
          lg = "lazygit";
          bt = "bluetui";
          sw = "nh os switch";
        };
      };
      programs = {
        atuin = {
          enable = true;
          enableZshIntegration = true;
        };
        eza = {
          enable = true;
          enableZshIntegration = true;
        };
        pay-respects = {
          enable = true;
          enableZshIntegration = true;
        };
        nix-your-shell = {
          enable = true;
          enableZshIntegration = true;
        };
        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv = {
            enable = true;
          };
        };
        zoxide = {
          enable = true;
          enableZshIntegration = true;
        };
        zsh = {
          enable = true;
          dotDir = "${config.xdg.configHome}/zsh";
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          history = {
            size = 100000;
            expireDuplicatesFirst = true;
            extended = true;
            ignoreAllDups = true;
            ignoreSpace = true;
            append = true;
          };
          historySubstringSearch = {
            enable = true;
            searchUpKey = "^[k";
            searchDownKey = "^[j";
          };
          oh-my-zsh = {
            enable = true;
            plugins = [
              "dirhistory"
              "colored-man-pages"
              "sudo"
              "git"
              "fancy-ctrl-z"
              "extract"
              "grc"
              "colorize"
            ];
          };
          plugins = with pkgs; [
            {
              name = "nix-shell";
              src = "${zsh-nix-shell}/share/zsh-nix-shell";
              file = "nix-shell.plugin.zsh";
            }
            {
              name = "fzf-tab";
              src = "${zsh-fzf-tab}/share/fzf-tab";
            }
            {
              name = "you-should-use";
              src = "${zsh-you-should-use}/share/zsh/plugins/you-should-use";
            }
            {
              name = "fzf-tab-source";
              src = fetchFromGitHub {
                owner = "Freed-Wu";
                repo = "fzf-tab-source";
                rev = "a06c2cf";
                sha256 = "sha256-0k6x4AhO8ULqanA+1bTNLhMGVz2A3K7LXQ/MgSLuQkc=";
              };
            }
          ];

          initContent =
            let
              secretTool = "${pkgs.libsecret}/bin/secret-tool";
              timeout = "${pkgs.coreutils}/bin/timeout";
              zshConfig = lib.mkOrder 1000 ''
                zstyle ':completion:*' menu no
                zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
                zstyle ':fzf-tab:*' use-fzf-default-opts yes

                bindkey -r '^J'
                bindkey -r '^K'

                typeset -ga secret_tool_env_entries=(
                  OPENAI_API_KEY
                  OPENROUTER_API_KEY_AVANTE
                )

                load_secret_tool_env() {
                  local env_name value
                  for env_name in ''${secret_tool_env_entries[@]}; do
                    [[ -n "''${(P)env_name}" ]] && continue

                    value="$(${timeout} 2s ${secretTool} lookup env "$env_name" 2>/dev/null)"
                    [[ -n "$value" ]] && export "$env_name=$value"
                  done
                }

                load_secret_tool_env
              '';

              devenvConfig = lib.mkOrder 3500 ''
                # eval "$(devenv hook zsh)"
              '';

            in
            lib.mkMerge [
              zshConfig
              devenvConfig
            ];
        };
      };
    };
}
