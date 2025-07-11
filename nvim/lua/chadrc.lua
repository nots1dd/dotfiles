-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}


M.base46 = {
	theme = "gruvbox",

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

M.nvdash = {
  load_on_startup = true,
  header = {
    "⬜⬜⬜⬜⬜⬜⬛⬛⬛⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬜⬜⬛⬛🟥🟥🟥🟥🟥⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜",
    "⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜",
    "⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥⬛⬛🟥🟥🟥⬛⬜⬜⬜⬜⬜",
    "⬜⬛🟥🟥🟥🟥🟥🟥⬛⬛⬜⬛🟥🟥🟥⬛⬜⬜⬜⬜⬜",
    "⬜⬛🟥🟥🟥🟥🟥⬛⬜⬜⬜⬛🟥🟥⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬛🟥🟥🟥⬛⬜⬜⬜⬛🟥🟥🟥⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬛🟥🟥⬛⬜⬜⬜⬛🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬛🟥🟥🟥⬛⬛⬛🟥🟥🟥⬛⬛⬜⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬜⬛🟥🟥🟥🟥🟥🟥🟥⬛🟥⬛⬜⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬜⬜⬛🟥🟥🟥🟥⬛⬛🟥🟥⬛⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬜⬜⬜⬛⬛⬛⬛🟥⬛🟥🟥🟥🟥⬛⬛⬜⬜⬜⬜",
    "⬜⬜⬜⬛⬛⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜",
    "⬜⬜⬛🟥⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜",
    "⬜⬜⬛⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟦🟥🟥🟥🟥⬛⬜⬜",
    "⬜⬜⬛⬛⬛🟥⬛🟥⬛⬛🟥🟦🟦🟦🟦🟦🟥🟥🟥⬛⬜",
    "⬜⬛🟥⬛🟥⬛⬛⬛🟥🟥🟥🟦🟦🟦🟦🟦🟦🟥🟥⬛⬜",
    "⬜⬛🟥⬛⬛🟥⬛🟥⬛⬛🟦🟦🟦⬛⬛🟦🟦🟦🟥⬛⬜",
    "⬜⬛🟥⬛🟥⬛⬛⬛🟥🟥🟦🟦⬛⬜⬜⬛🟦🟦🟦🟥⬛",
    "⬜⬛🟥⬛🟥🟥⬛🟥🟥🟦🟦⬛⬜⬜⬜⬛🟦🟦🟦🟥⬛",
    "",
    "  Hello Sidd - " .. os.date("%A, %d %B %Y  %H:%M:%S"),
    "  NVIM (" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch .. ") session in '" .. vim.fn.getcwd() .. "'",
    "  OS: " .. get_os_info(),
    "",
  },

  buttons = {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files", hl = "NvDashFind" },
    { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles", hl = "NvDashRecent" },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  }
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
