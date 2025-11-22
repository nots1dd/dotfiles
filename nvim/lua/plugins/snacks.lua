return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = {
      enabled = true,
    },
    scroll = {
      enabled = true,
    },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { key = "ff", action = "<leader>ff", desc = "Find File", icon = " " },
          { key = "fo", action = "<leader>fo", desc = "Recent Files", icon = " " },
          { key = "cw", action = "<leader>cw", desc = "Yazi", icon = " " },
          { key = "fw", action = "<leader>fw", desc = "Telescope", icon = " " },
        },
      },
      sections = {
        {
          section = "terminal",
          cmd = "chafa ~/Pictures/nvim.png --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
          height = 20,
          padding = 1,
        },
        {
          pane = 2,
          section = "terminal",
          cmd = "/usr/bin/colorscript -e crunchbang-mini",
          height = 5,
          padding = 1,
        },
        {
          section = "keys",
          gap = 1,
          padding = 1,
        },
        function()
          local in_git = function()
            return require("snacks.git").get_root() ~= nil
          end
          local cmds = {
            {
              title = "Notifications",
              cmd = "gh notify -s -a -n5",
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
              key = "n",
              icon = " ",
              height = 5,
              enabled = true,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 5,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3",
              key = "P",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 5,
            },
            {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C",
              height = 10,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        {
          section = "startup",
        },
      },
      style = {
        width = 0.7,
        height = 0.75,
        zindex = 50,
        wo = {
          border = "rounded",
          winhighlight = "Normal:SnacksDashboardNormal,NormalFloat:SnacksDashboardNormal",
        },
      },
    },
  },
}
