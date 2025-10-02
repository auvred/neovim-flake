local nix_generated = require("auvred.nix-generated")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config('nixd', {
  cmd = { nix_generated.nixd_server_path },
  capabilities = capabilities,
})
vim.lsp.enable('nixd')

vim.lsp.config('ts_ls', {
  cmd = { nix_generated.typescript_language_server_path, "--stdio" },
  on_attach = function(client, bufnr)
    require("twoslash-queries").attach(client, bufnr)
  end,
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = nix_generated.vue_typescript_plugin_path,
        languages = { "vue" },
      },
    },
  },
  filetypes = {
    "javascript", 
    "javascriptreact", 
    "javascript.jsx", 
    "typescript", 
    "typescriptreact", 
    "typescript.tsx", 
    "vue",
  },
})
vim.lsp.enable('ts_ls')

vim.lsp.config('vue_ls', {
  cmd = { nix_generated.vue_language_server_path, "--stdio" },
  capabilities = capabilities,
})
vim.lsp.enable('vue_ls')

vim.lsp.config('clangd', {
  cmd = { nix_generated.clangd_server_path },
})
vim.lsp.enable('clangd')

vim.lsp.config('jsonnet_ls', {
  cmd = { nix_generated.jsonnet_server_path },
})
vim.lsp.enable('jsonnet_ls')

vim.lsp.config('gopls', {
  cmd = { nix_generated.gopls_server_path },
})
vim.lsp.enable('gopls')

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }

    local telescope_builtin = require("telescope.builtin")

    vim.keymap.set("n", "<leader>gd", telescope_builtin.lsp_definitions, opts)
    vim.keymap.set("n", "<leader>gr", telescope_builtin.lsp_references, opts)
    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "<leader>gT", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    vim.keymap.set("n", "<leader>dn", function()
      vim.diagnostic.jump({ count = 1, severity = { min = vim.diagnostic.severity.WARN } })
    end, opts)
    vim.keymap.set("n", "<leader>dp", function()
      vim.diagnostic.jump({ count = -1, severity = { min = vim.diagnostic.severity.WARN } })
    end, opts)
    vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, opts)
  end,
})

vim.diagnostic.config({
  signs = false,
})

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "single"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
