{ den, ... }:
{
  den.aspects.tui._.nvim.homeManager =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      inherit (config.lib.stylix) colors;
      hex = str: "#${str}";
      path = "${config.var.configDir}/modules/tui/nvim";

      nvim-spell-pl-utf8-dictionary = builtins.fetchurl {
        url = "https://ftp.uni-bayreuth.de/packages/editors/vim/runtime/spell/pl.utf-8.spl";
        sha256 = "sha256:1sg7hnjkvhilvh0sidjw5ciih0vdia9vas8vfrd9vxnk9ij51khl";
      };
    in
    {
      programs.neovim = {
        enable = true;
        vimAlias = true;
        viAlias = true;
        withPython3 = true;
        withRuby = true;
        extraPackages = with pkgs; [
          sqlit-tui
          fd
          # fzf
          fzy
          luarocks
          ripgrep
          lazygit
          nodejs_24
          gcc
          llvmPackages_21.clang-unwrapped
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
      };

      stylix.targets.neovim.enable = lib.mkForce false;

      xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

      home = {
        sessionVariables = {
          RUST_DAP = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/";
        };

        shellAliases.n = "nvim";

        file = {
          ".config/nvim" = {
            source = config.lib.file.mkOutOfStoreSymlink "${path}";
          };
          ".config/nixos/modules/tui/nvim/spell/pl.utf-8.spl".source = nvim-spell-pl-utf8-dictionary;
          ".config/nixos/modules/tui/nvim/lua/plugins/editor/ui/colorscheme.lua".text =
            # lua
            ''
              return {
                {
                  "LazyVim/LazyVim",
                  opts = function(_, opts)
                    opts.colorscheme = "catppuccin-mocha"
                    -- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ecbe7b" })
                    -- vim.api.nvim_set_hl(0, "TabLineFill", { fg = "#dfdfdf", bg = "#1d2021" })
                    -- vim.api.nvim_set_hl(0, "TabLine", { fg = "#dfdfdf", bg = "#1d2021" })
                    -- vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#1d2021" })
                    -- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#1b1b1b" })
                    -- vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "#1d2021", fg = "#51afef" })
                  end,
                },
                {
                  "catppuccin/nvim",
                  opts = function(_, opts)
                    opts.color_overrides = {
                      all = {
                        base = "${hex colors.base00}",
                        mantle = "${hex colors.base01}",
                      }
                    }
                  return opts end
                },
                { "sainnhe/gruvbox-material" },
              }
            '';
        };
      };
    };
}
