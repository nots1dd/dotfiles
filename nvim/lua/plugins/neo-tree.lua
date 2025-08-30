return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree focus<cr>", desc = "Focus Neo-tree" },
      { "<leader>o", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    },
    config = function()
      require("neo-tree").setup({
          filesystem = {
            bind_to_cwd = true,          -- let Neo-tree track cwd
            cwd_target = "current",      -- open in current cwd
            sync_root_with_cwd = true,   -- sync Neo-tree root with cwd
            respect_buf_cwd = true,      -- respect buffer-local cwd
            follow_current_file = {
              enabled = true,            -- follow file as you switch buffers
              leave_dirs_open = false,
          },
          hijack_netrw_behavior = "open_default",

          window = {
            mappings = {
              -- Navigate in/out of directories
              ["l"] = "open",           -- go inside dir / open file
              ["h"] = "close_node",     -- collapse directory
              ["<BS>"] = "navigate_up", -- go outside (parent dir)
              ["<CR>"] = "open",        -- enter
              ["--"] = "navigate_up",   -- go up one directory
              ["=="] = "set_root",      -- cd into directory

              ["/"] = "fuzzy_finder",   -- start fuzzy filename search
              ["f"] = "filter_on_submit", -- filter by exact input
              ["<C-x>"] = "clear_filter", -- clear filter

              -- Jump to special dirs
              ["~"] = {
                function(state)
                  require("neo-tree.command").execute({ action = "focus", source = "filesystem", dir = vim.fn.expand("~") })
                end,
                desc = "Go to home directory",
              },
              ["`"] = {
                function(state)
                  require("neo-tree.command").execute({ action = "focus", source = "filesystem", dir = "/" })
                end,
                desc = "Go to root directory",
              },
              ["c"] = {
                function(state)
                  require("neo-tree.command").execute({ action = "focus", source = "filesystem", dir = vim.loop.cwd() })
                end,
                desc = "Go to current working directory",
              },

              -- Toggle executable permission (Unix only)
              ["x"] = {
                function(state)
                  local node = state.tree:get_node()
                  if node and node.type == "file" then
                    local path = node:get_id()
                    vim.fn.system({ "chmod", "+x", path })
                    vim.notify("Made " .. path .. " executable", vim.log.levels.INFO)
                  end
                end,
                desc = "Make file executable",
              },

              ["D"] = {
                function(state)
                  local node = state.tree:get_node()
                  if node then
                    vim.fn.system({ "trash-put", node:get_id() })
                    require("neo-tree.sources.manager").refresh(state.name)
                  end
                end,
                desc = "Move file to trash",
              },

              ["i"] = {
                function(state)
                  local node = state.tree:get_node()
                  if not node then return end

                  local path = node:get_id()
                  local stat = vim.loop.fs_stat(path)
                  if not stat then return end

                  -- Convert size into human readable (e.g., KB/MB)
                  local function human_size(bytes)
                    local units = { "B", "KB", "MB", "GB", "TB" }
                    local i = 1
                    while bytes > 1024 and i < #units do
                      bytes = bytes / 1024
                      i = i + 1
                    end
                    return string.format("%.1f %s", bytes, units[i])
                  end

                  -- Safe date formatter
                  local function fmt_time(t)
                    return t and os.date("%Y-%m-%d %H:%M:%S", t.sec) or "N/A"
                  end

                  local msg = string.format(
                    "File: %s\nSize: %s\nType: %s\nCreated: %s\nModified: %s",
                    vim.fn.fnamemodify(path, ":t"),
                    human_size(stat.size),
                    stat.type,
                    fmt_time(stat.birthtime),
                    fmt_time(stat.mtime)
                  )

                  vim.notify(msg, vim.log.levels.INFO, { title = "File Info" })
                end,
                desc = "Show file information",
              },

              -- Preview files (images, pdf, etc.)
              ["p"] = {
                function(state)
                  local node = state.tree:get_node()
                  if node and node.type == "file" then
                    local path = node:get_id()
                    local ext = path:match("^.+%.(.+)$") or ""

                    if ext == "png" or ext == "jpg" or ext == "jpeg" or ext == "gif" then
                      vim.fn.jobstart({ "feh", path }, { detach = true }) -- image viewer
                    elseif ext == "pdf" then
                      vim.fn.jobstart({ "zathura", path }, { detach = true }) -- pdf viewer
                    else
                      vim.cmd("edit " .. path) -- fallback: open in buffer
                    end
                  end
                end,
                desc = "Preview file",
              },

              -- File ops
              ["yy"] = "copy_to_clipboard",   -- copy file path
              ["pp"] = "paste_from_clipboard", -- paste/move file
              ["dd"] = "delete",              -- delete file
              ["r"]  = "rename",              -- rename
              ["a"]  = "add",                 -- new file / dir
            },
          },
        },
      })
    end,
  },

  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },

  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          bo = {
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
}
