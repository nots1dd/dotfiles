return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    local nvim_tree = require("nvim-tree")
    local tree_api = require("nvim-tree.api")

    -- Make file executable
    local function make_file_executable(node)
      local file = node.absolute_path
      if vim.fn.filereadable(file) == 1 then
        vim.fn.system({ "chmod", "+x", file })
        vim.notify("✅ Made executable: " .. file, vim.log.levels.INFO)
      else
        vim.notify("❌ Not a valid file: " .. file, vim.log.levels.ERROR)
      end
    end

    -- Move file
    local function move_file(node)
      local source = node.absolute_path
      if vim.fn.filereadable(source) ~= 1 and vim.fn.isdirectory(source) ~= 1 then
        vim.notify("❌ Not a valid file or directory: " .. source, vim.log.levels.ERROR)
        return
      end

      vim.ui.input({ prompt = "Move to: ", default = source }, function(dest)
        if dest and dest ~= "" then
          local ok, err = os.rename(source, dest)
          if ok then
            vim.notify("✅ Moved to: " .. dest, vim.log.levels.INFO)
            tree_api.tree.reload()
          else
            vim.notify("❌ Move failed: " .. err, vim.log.levels.ERROR)
          end
        end
      end)
    end

    -- On attach
    local function my_on_attach(bufnr)
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      local api = require("nvim-tree.api")
      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set("n", "--", api.tree.change_root_to_parent, opts("Up directory"))
      vim.keymap.set("n", "==", api.tree.change_root_to_node, opts("CD into directory"))

      vim.keymap.set("n", "X", function()
        local node = api.tree.get_node_under_cursor()
        if node then make_file_executable(node) end
      end, opts("Chmod +x file"))

      vim.keymap.set("n", "M", function()
        local node = api.tree.get_node_under_cursor()
        if node then move_file(node) end
      end, opts("Move file"))
    end

    -- Setup nvim-tree
    nvim_tree.setup({
      on_attach = my_on_attach,
      view = {
        width = 40,
        side = "left",
      },
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
    })

    -- Optional: auto-open tree and force root to cwd on startup
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local cwd = vim.fn.getcwd()
        tree_api.tree.open()
        tree_api.tree.change_root(cwd)
      end,
    })
  end,
}
