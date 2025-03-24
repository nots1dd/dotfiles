return {
  "mrcjkb/rustaceanvim",
  version = "^5", -- Recommended version
  lazy = false,   -- This plugin is already lazy
  ft = { "rust" }, -- Load only for Rust files
  config = function()
    -- Rustaceanvim configuration goes here
    vim.g.rustaceanvim = {
      server = {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      },
    }
  vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })
  end,
}
