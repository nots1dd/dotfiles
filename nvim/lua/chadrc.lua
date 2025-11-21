-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "gruvchad",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

M.ui = {
  telescope = { style = "bordered" },
  statusline = {
    enabled = true,
    theme = "default", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "arrow",
    order = nil,
    modules = nil,
  },
  colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
  }
}

local function get_os_info()
  return vim.loop.os_uname().sysname .. " " .. vim.loop.os_uname().release
end

local function get_packages()
  -- works for arch (pacman), fallback to generic count
  local pkg = vim.fn.system("pacman -Q | wc -l 2>/dev/null")
  pkg = tonumber(pkg) or "?"
  return pkg
end

local function get_uptime()
  local up = vim.fn.system("uptime -p 2>/dev/null"):gsub("\n", "")
  return up ~= "" and up or "unknown"
end

M.nvdash = {
  load_on_startup = true,

  header = {
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ",
    "",
    "───────────────────────────────────────────────────────────",
    "",
    "  OS: " .. get_os_info(),
    "  Kernel: " .. vim.loop.os_uname().release,
    "  Shell: " .. os.getenv("SHELL"),
    "  Terminal: " .. (os.getenv("TERM") or "unknown"),
    "  Uptime: " .. get_uptime(),
    "",
    "───────────────────────────────────────────────────────────",
    "  Welcome back, nots1dd — " .. os.date("%A, %d %B %Y %H:%M:%S"),
    "",
  },

  buttons = {
    { txt = "  Find File",     keys = "ff", cmd = "Telescope find_files", hl = "NvDashFind" },
    { txt = "  Recent Files",  keys = "fo", cmd = "Telescope oldfiles", hl = "NvDashRecent" },
    { txt = "  File Browser",  keys = "cw", cmd = "Open Yazi",          hl = "NvDashRecent" },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. "ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
}

M.colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
}

M.lsp = {
  signature = true
}


return M
