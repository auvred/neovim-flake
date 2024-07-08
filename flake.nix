{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };
  outputs = {
    self,
    nixpkgs,
    neovim-nightly-overlay,
    treefmt-nix,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        neovim-nightly-overlay.overlays.default
        (final: prev: {
          vimPlugins = (prev.lib.foldr (a: b: b.extend a) prev.vimPlugins) [
            (import ./overlays/cmp-buffer)
            (import ./overlays/cmp-nvim-lsp)
            (import ./overlays/cmp-path)
          ];
        })
      ];
    };
  in {
    packages.${system}.nvim = let
      # neovim-nightly-overlay overrides the neovim-unwrapped derivation, but outputs it as neovim
      neovim-unwrapped = pkgs.neovim;
      auvred-config = pkgs.stdenv.mkDerivation {
        name = "auvred-neovim-config";
        srcs = [./lua ./plugin];
        sourceRoot = ".";
        installPhase = ''
          mkdir -p $out
          cp -r ./. $out
          cat << EOF > $out/lua/auvred/nix-generated.lua
          local M = {
            nixd_server_path = "${pkgs.nixd}/bin/nixd",
            typescript_language_server_path = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server",
            vue_typescript_plugin_path = "${pkgs.vue-language-server}/lib/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
            vue_language_server_path = "${pkgs.vue-language-server}/bin/vue-language-server",
          }
          return M
          EOF
        '';
      };
      runtimepath = let
        flattenDeps = plugins: plugins ++ (pkgs.lib.unique (builtins.concatLists (builtins.map (plugin: flattenDeps (plugin.dependencies or [])) plugins)));
      in
        flattenDeps ([auvred-config]
          ++ (with pkgs.vimPlugins; [
            catppuccin-nvim
            nvim-treesitter
            nvim-treesitter-context
            telescope-nvim
            comment-nvim
            nvim-lspconfig
            (nvim-cmp.overrideAttrs {dependencies = [cmp-nvim-lsp cmp-buffer cmp-path];})
            (oil-nvim.overrideAttrs {dependencies = [nvim-web-devicons];})
            harpoon2
          ])
          ++ builtins.filter pkgs.lib.isDerivation (builtins.attrValues pkgs.vimPlugins.nvim-treesitter-parsers));
      initLua = pkgs.writeTextDir "auvred-nvim-config-init.lua" ''
        ${builtins.concatStringsSep "\n" (builtins.map (p: "vim.opt.rtp:append('${p}')") runtimepath)}
        require('auvred')
      '';
      makeWrapperArgs = [
        "${neovim-unwrapped}/bin/nvim"
        "${placeholder "out"}/bin/nvim"
        "--add-flags"
        "-u ${initLua}/auvred-nvim-config-init.lua"
      ];
    in
      pkgs.stdenv.mkDerivation {
        name = "neovim";
        dontUnpack = true;
        buildPhase = ''
          runHook preBuild
          mkdir -p $out
          for i in ${neovim-unwrapped}; do
            lndir -silent $i $out
          done
          runHook postBuild
        '';
        postBuild = ''
          rm $out/bin/nvim
          makeWrapper ${pkgs.lib.escapeShellArgs makeWrapperArgs}
        '';
        nativeBuildInputs = [pkgs.makeWrapper pkgs.xorg.lndir];
      };
    apps.${system}.default = {
      type = "app";
      program = "${self.packages.${system}.nvim}/bin/nvim";
    };
    formatter.${system} =
      (treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs = {
          alejandra.enable = true;
          stylua.enable = true;
        };
      })
      .config
      .build
      .wrapper;
  };
}
