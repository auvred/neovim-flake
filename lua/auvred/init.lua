for _, plugin_config_path in
  ipairs(vim.api.nvim_get_runtime_file("lua/auvred/plugins/*.lua", true))
do
  for filename in string.gmatch(plugin_config_path, "/([^/]+).lua$") do
    require("auvred.plugins." .. filename)
  end
end
