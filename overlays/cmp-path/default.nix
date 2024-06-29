# :h after-directory
# tldr: neovim won't automatically load after/* files from runtimepath
final: prev: {
  cmp-path = prev.cmp-path.overrideAttrs {
    patches = [./setup_in_plugin_dir.patch];
  };
}
