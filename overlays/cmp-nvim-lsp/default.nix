# :h after-directory
# tldr: neovim won't automatically load after/* files from runtimepath
#
# https://github.com/hrsh7th/cmp-nvim-lsp/issues/60 -> https://github.com/hrsh7th/cmp-nvim-lsp/pull/61
final: prev: {
  cmp-nvim-lsp = prev.cmp-nvim-lsp.overrideAttrs {
    patches = [
      ./setup_in_plugin_dir.patch
    ];
  };
}
