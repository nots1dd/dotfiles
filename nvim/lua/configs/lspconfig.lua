require("nvchad.configs.lspconfig").defaults()

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--suggest-missing-includes",
    "--all-scopes-completion",
    "--cross-file-rename",
    "--pretty",
    "--log=verbose",
  },

  init_options = {
    clangdFileStatus = true,
    fallbackFlags = {}, -- filled in dynamically
  },

  -------------------------------------------------------
  -- DYNAMIC STANDARD SELECTION (C23 for C, C++20 for C++)
  -------------------------------------------------------
  on_new_config = function(config, root_dir)
    local fname = vim.api.nvim_buf_get_name(0)
    local ext = fname:match("^.+(%..+)$") or ""

    if ext == ".c" or ext == ".h" then
      config.init_options.fallbackFlags = { "-std=c23" }
      print("[clangd] Using C23 for file:", fname)
    else
      config.init_options.fallbackFlags = { "-std=c++20" }
      print("[clangd] Using C++20 for file:", fname)
    end
  end,

  handlers = {

    ["textDocument/hover"] = function(err, result)
      if err or not result then return end

      local md = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      md = vim.lsp.util.trimempty(md)
      if vim.tbl_isempty(md) then return end

      return vim.lsp.util.open_floating_preview(md, "markdown", {
        border = "rounded",
      })
    end,

    ["textDocument/signatureHelp"] = function(err, result)
      if err or not result then return end

      local lines = vim.lsp.util.convert_signature_help_to_markdown_lines(result)
      lines = vim.lsp.util.trimempty(lines)
      if vim.tbl_isempty(lines) then return end

      return vim.lsp.util.open_floating_preview(lines, "markdown", {
        border = "rounded",
      })
    end,

    ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
      config = vim.tbl_extend("force", config or {}, {
        underline = true,
        signs = true,
        virtual_text = true,
        update_in_insert = false,
      })
      vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
    end,
  },

  on_attach = function(client, bufnr)
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
})

vim.lsp.enable({ "html", "cssls", "clangd", "cmake", "bash" })
