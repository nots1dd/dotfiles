return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    local tree_api = require("nvim-tree.api")

    local function my_on_attach(bufnr)
      local function opts(desc)
        return { desc = "NvimTree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Load default NvimTree mappings
      tree_api.config.mappings.default_on_attach(bufnr)

      -- Custom mappings
      local keymap = vim.keymap.set
      keymap("n", "--", tree_api.tree.change_root_to_parent, opts("Go to parent directory"))
      keymap("n", "==", tree_api.tree.change_root_to_node, opts("Enter selected directory"))
    end

    require("nvim-tree").setup({
      on_attach = my_on_attach, -- Attach function
    })
  end,
}
