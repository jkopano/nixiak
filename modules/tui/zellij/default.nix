# Zellij terminal multiplexer configuration
{ den, ... }:
{
  den.aspects.tui._.zellij.homeManager =
    { config, ... }:
    {
      home.sessionVariables = {
        "ZELLIJ_SESSION_FILE" = "${config.var.configDir}/modules/home/tui/tmux/tmux_sessions";
      };
      programs.zellij = { enable = true; };

      home.file.".config/zellij/config.kdl".text = ''
        simplified_ui true
        default_layout "compact"
        plugins {
          autolock location="https://github.com/fresh2dev/zellij-autolock/releases/latest/download/zellij-autolock.wasm" {
              is_enabled true
              triggers "nvim|vim|v|nv"
              watch_triggers "fzf|zoxide|atuin|atac"
              watch_interval "1.0"
          }
        }
        load_plugins {
          autolock
        }
        keybinds clear-defaults=true {
          shared_except "tmux" {
            bind "Ctrl s" { SwitchToMode "tmux"; }
            bind "Ctrl Enter" { NewPane; }
            bind "Ctrl q" { CloseFocus; }
            bind "Ctrl H" { Resize "Increase Left"; }
            bind "Ctrl J" { Resize "Increase Down"; }
            bind "Ctrl K" { Resize "Increase Up"; }
            bind "Ctrl L" { Resize "Increase Right"; }
            bind "Alt 1" { GoToTab 1; SwitchToMode "Normal"; }
            bind "Alt 2" { GoToTab 2; SwitchToMode "Normal"; }
            bind "Alt 3" { GoToTab 3; SwitchToMode "Normal"; }
            bind "Alt 4" { GoToTab 4; SwitchToMode "Normal"; }
            bind "Alt 5" { GoToTab 5; SwitchToMode "Normal"; }
            bind "Alt 6" { GoToTab 6; SwitchToMode "Normal"; }
            bind "Alt 7" { GoToTab 7; SwitchToMode "Normal"; }
            bind "Alt 8" { GoToTab 8; SwitchToMode "Normal"; }
            bind "Alt 9" { GoToTab 9; SwitchToMode "Normal"; }
            bind "Alt [" { PreviousSwapLayout; }
            bind "Alt ]" { NextSwapLayout; }
          }
          tmux {
            bind "Ctrl s" { SwitchToMode "Normal"; }
            bind "Esc" { SwitchToMode "Normal"; }

            bind "Ctrl e" { WriteChars "$EDITOR ."; Write 13; SwitchToMode "Normal"; }

            bind "Ctrl u" { CloseFocus; SwitchToMode "Normal"; }
            bind "z" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
            bind "d" { Detach; }
            bind "s" { ToggleActiveSyncTab; SwitchToMode "Normal"; }

            bind "h" { MoveFocus "Left"; SwitchToMode "Normal"; }
            bind "l" { MoveFocus "Right"; SwitchToMode "Normal"; }
            bind "j" { MoveFocus "Down"; SwitchToMode "Normal"; }
            bind "k" { MoveFocus "Up"; SwitchToMode "Normal"; }

            bind "c" { NewTab; SwitchToMode "Normal"; }
            bind "Ctrl l" { GoToNextTab; SwitchToMode "Normal"; }
            bind "Ctrl h" { GoToPreviousTab; SwitchToMode "Normal"; }
          }
          shared_except "locked" "tmux" {
            bind "Ctrl h" "Alt Left" { MoveFocusOrTab "Left"; }
            bind "Ctrl l" "Alt Right" { MoveFocusOrTab "Right"; }
            bind "Ctrl j" "Alt Down" { MoveFocus "Down"; }
            bind "Ctrl k" "Alt Up" { MoveFocus "Up"; }
          }
        }
      '';
    };
}
