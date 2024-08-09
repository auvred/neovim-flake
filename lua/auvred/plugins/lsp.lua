local nix_generated = require("auvred.nix-generated")
local lspconfig = require("lspconfig")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.nixd.setup({
  cmd = { nix_generated.nixd_server_path },
  capabilities = capabilities,
})

lspconfig.tsserver.setup({
  cmd = { nix_generated.typescript_language_server_path, "--stdio" },
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
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
  },
})

lspconfig.volar.setup({
  cmd = { nix_generated.vue_language_server_path, "--stdio" },
  capabilities = capabilities,
})

lspconfig.clangd.setup({
  cmd = { nix_generated.clangd_server_path },
})

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
      vim.diagnostic.jump({ count = 1 })
    end, opts)
    vim.keymap.set("n", "<leader>dp", function()
      vim.diagnostic.jump({ count = -1 })
    end, opts)
    vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, opts)
  end,
})
