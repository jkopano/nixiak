{ den, ... }:
{
  den.aspects.tui._.helix.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.lib.stylix) colors;
    in
    {
      stylix.targets.helix.enable = lib.mkForce false;

      programs.helix = {
        enable = true;

        extraPackages = with pkgs; [
          fd
          ripgrep
          nodejs_24
          gcc
          llvmPackages_21.clang-unwrapped
          llvmPackages_21.clang-tools
          ghc
          python313

          nixd
          statix

          glsl_analyzer
          haskell-language-server
          rust-analyzer
          tinymist
          lua-language-server
          fennel-ls
          shellcheck
          csharpier
          gdtoolkit_4
          zls
          neocmakelsp

          markdownlint-cli2
          nixfmt
          shfmt
          stylua
          marksman
          taplo

          netcoredbg
          vscode-extensions.vadimcn.vscode-lldb
        ];

        settings = {
          editor = {
            line-number = "relative";
            mouse = true;
            cursorline = true;
            color-modes = true;
            bufferline = "multiple";
            true-color = true;
            completion-trigger-len = 1;
            auto-format = true;
            end-of-line-diagnostics = "hint";

            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };

            indent-guides = {
              render = true;
              character = "╎";
              skip-levels = 1;
            };

            lsp = {
              display-messages = true;
              auto-signature-help = true;
              display-inlay-hints = false;
            };

            inline-diagnostics = {
              cursor-line = "warning";
              other-lines = "disable";
            };
          };

          keys = {
            normal = {
              J = "match_brackets";
              backspace = "goto_last_accessed_file";
              C-f = [
                "page_down"
                "align_view_center"
              ];
              C-b = [
                "page_up"
                "align_view_center"
              ];
              C-d = [
                "page_cursor_half_down"
                "align_view_center"
              ];
              C-u = [
                "page_cursor_half_up"
                "align_view_center"
              ];

              space = {
                space = "file_picker";
                "," = "buffer_picker";
                "/" = "global_search";
                e = "file_explorer";
                Q = ":quit-all!";

                f = {
                  f = "file_picker";
                  g = "changed_file_picker";
                  b = "buffer_picker";
                };

                s = {
                  g = "global_search";
                  b = "search_selection";
                  d = "diagnostics_picker";
                  D = "workspace_diagnostics_picker";
                  s = "symbol_picker";
                  S = "workspace_symbol_picker";
                };

                c = {
                  a = "code_action";
                  r = "rename_symbol";
                  f = ":format";
                  d = "diagnostics_picker";
                };

                w = {
                  w = ":write";
                  a = ":write-all";
                  q = "wclose";
                  o = "wonly";
                  s = "hsplit";
                  v = "vsplit";
                  h = "jump_view_left";
                  j = "jump_view_down";
                  k = "jump_view_up";
                  l = "jump_view_right";
                };
              };
            };

            insert = {
              A-h = "move_char_left";
              A-j = "move_visual_line_down";
              A-k = "move_visual_line_up";
              A-l = "move_char_right";
            };
          };
        };

        languages = {
          language-server = {
            clangd = {
              command = "clangd";
              args = [
                "--background-index"
                "--clang-tidy"
                "--header-insertion=iwyu"
                "--completion-style=detailed"
                "--function-arg-placeholders"
                "--fallback-style=llvm"
                "--j=8"
                "--pch-storage=disk"
              ];
              config.fallbackFlags = [ "-std=c++23" ];
            };

            pyright = {
              command = "uv";
              args = [
                "run"
                "pyright-langserver"
                "--stdio"
              ];
            };

            ruff = {
              command = "uv";
              args = [
                "run"
                "ruff"
                "server"
              ];
            };
          };

          language = [
            {
              name = "c";
              language-servers = [ "clangd" ];
            }
            {
              name = "cpp";
              language-servers = [ "clangd" ];
            }
            {
              name = "python";
              language-servers = [
                "pyright"
                {
                  name = "ruff";
                  except-features = [ "hover" ];
                }
              ];
            }
            {
              name = "nix";
              language-servers = [ "nixd" ];
              formatter.command = "nixfmt";
              auto-format = true;
            }
            {
              name = "bash";
              formatter = {
                command = "shfmt";
                args = [ "-" ];
              };
              auto-format = true;
            }
            {
              name = "lua";
              language-servers = [ "lua-language-server" ];
              formatter = {
                command = "stylua";
                args = [ "-" ];
              };
              auto-format = true;
            }
            {
              name = "toml";
              language-servers = [ "taplo" ];
              formatter = {
                command = "taplo";
                args = [
                  "fmt"
                  "-"
                ];
              };
              auto-format = true;
            }
            {
              name = "c-sharp";
              formatter = {
                command = "/home/kuba/.dotnet/tools/dotnet-csharpier";
                args = [ "--write-stdout" ];
              };
              auto-format = true;
            }
          ];
        };

        ignores = [ "*.gd.uid" ];
      };
    };
}
