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
    lazy = false,

    keys = {
      { "<leader>e", "<cmd>Neotree focus<cr>",  desc = "Focus Neo-tree" },
      { "<leader>o", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    },

    config = function()
      require("neo-tree").setup({

        -- --- GENERAL OPTIONS --- --
        close_if_last_window = true,
        popup_border_style = "rounded",
        default_component_configs = {
          indent = {
            padding = 1,
            with_markers = true,
            expander_collapsed = "",
            expander_expanded = "",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            default = "",
          },
          git_status = {
            symbols = {
              added     = "",
              modified  = "",
              deleted   = "",
              renamed   = "",
              untracked = "",
              ignored   = "",
              unstaged  = "󰄱",
              staged    = "",
              conflict  = "",
            },
          },
        },

        -- --- FILESYSTEM OPTIONS --- --
        filesystem = {
          bind_to_cwd = true,
          cwd_target = "current",
          sync_root_with_cwd = true,
          respect_buf_cwd = true,

          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },

          hijack_netrw_behavior = "open_default",
        },

        -- --- WINDOW + MAPPINGS --- --
        window = {
          position = "left",
          width = 35,

          mappings = {
            ["<CR>"] = "open",
            ["l"]    = "open",
            ["h"]    = "close_node",
            ["<BS>"] = "navigate_up",
            ["--"]   = "navigate_up",
            ["=="]   = "set_root",

            -- Recursive search (built-in Neo-tree fuzzy finder)
            ["F"] = "fuzzy_finder",
            ["o"] = {
              function(state)
                local node = state.tree:get_node()
                if not node then
                  print("[Neo-tree] No node selected.")
                  return
                end

                local path = node:get_id()

                -- print the command being executed
                print("[Neo-tree] xdg-open → " .. path)

                -- run xdg-open and capture stderr for errors
                vim.fn.jobstart(
                  { "xdg-open", path },
                  {
                    detach = true,
                    on_stderr = function(_, data, _)
                      if data and #data > 0 then
                        print("[Neo-tree] xdg-open error: " .. table.concat(data, "\n"))
                      end
                    end,
                    on_exit = function(_, code, _)
                      if code ~= 0 then
                        print("[Neo-tree] xdg-open exited with code: " .. code)
                      end
                    end,
                  }
                )
              end,
              desc = "Open any file",
            },

            ["R"] = "refresh",

            ["<C-x>"] = "clear_filter",

            ["~"] = {
              function()
                require("neo-tree.command").execute({
                  action = "focus",
                  source = "filesystem",
                  dir = vim.fn.expand("~"),
                })
              end,
              desc = "Go to home",
            },
            ["`"] = {
              function()
                require("neo-tree.command").execute({
                  action = "focus",
                  source = "filesystem",
                  dir = "/",
                })
              end,
              desc = "Go to root directory",
            },
            ["c"] = {
              function()
                local file = vim.fn.expand("%:p") -- absolute path of current buffer
                if file == "" then
                  print("[Neotree] No file loaded.")
                  return
                end

                -- resolve directory
                local dir = vim.fn.fnamemodify(file, ":h")

                print("[Neotree] Resolving to directory: " .. dir)

                require("neo-tree.command").execute({
                  action = "focus",
                  source = "filesystem",
                  position = "left",
                  reveal_file = file,
                  reveal_force_cwd = true,
                })
              end,
              desc = "Go to file's directory",
            },

            ["yy"] = "copy_to_clipboard",
            ["pp"] = "paste_from_clipboard",
            ["dd"] = "delete",
            ["r"]  = "rename",
            ["a"]  = "add",

            ["yp"] = {
              function(state)
                local node = state.tree:get_node()
                if not node then return end

                local path = node:get_id() -- absolute absolute_path
                vim.fn.setreg("+", path)   -- copy to clipboard
                print("[Neotree] Copied absolute path: " .. path)
              end,
              desc = "Copy absolute path",
            },

            ["D"] = {
              function(state)
                local node = state.tree:get_node()
                vim.fn.system({ "trash-put", node:get_id() })
                require("neo-tree.sources.manager").refresh(state.name)
              end,
              desc = "Move file to trash",
            },

            ["x"] = {
              function(state)
                local node = state.tree:get_node()
                if node and node.type == "file" then
                  local path = node:get_id()
                  vim.fn.system({ "chmod", "+x", path })
                  print("[Neotree] Made " .. path .. " executable", vim.log.levels.INFO)
                end
              end,
              desc = "Make executable",
            },

            ["i"] = {
              function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                local stat = vim.loop.fs_stat(path)
                if not stat then return end

                local function hsize(s)
                  local u = { "B", "KB", "MB", "GB", "TB" }
                  local i = 1
                  while s > 1024 and i < #u do
                    s = s / 1024
                    i = i + 1
                  end
                  return string.format("%.1f %s", s, u[i])
                end

                print(
                  string.format(
                    "File: %s\nSize: %s\nType: %s\nModified: %s",
                    vim.fn.fnamemodify(path, ":t"),
                    hsize(stat.size),
                    stat.type,
                    os.date("%Y-%m-%d %H:%M:%S", stat.mtime.sec)
                  ),
                  vim.log.levels.INFO,
                  { title = "File Info" }
                )
              end,
              desc = "File Info",
            },

            ["p"] = {
              function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                local ext = path:match("^.+%.(.+)$") or ""

                local img = { png=1, jpg=1, jpeg=1, gif=1 }
                if img[ext] then
                  vim.fn.jobstart({ "feh", path }, { detach = true })
                elseif ext == "pdf" then
                  vim.fn.jobstart({ "zathura", path }, { detach = true })
                else
                  vim.cmd("edit " .. path)
                end
              end,
              desc = "Preview",
            },
          },
        }
      })
    end,
  },

  -- File operations (mv, cp, rm via LSP)
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-neo-tree/neo-tree.nvim" },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },

  -- Picker
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
