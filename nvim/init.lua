vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
  callback = function()
    if not vim.g.skip_format_on_write then
      vim.lsp.buf.format({ async = false })
    end
  end,
})

-- Create :Wp command to write without formatting
vim.api.nvim_create_user_command("Wp", function()
  vim.g.skip_format_on_write = true
  vim.cmd("write")
  vim.g.skip_format_on_write = false
end, {})

vim.schedule(function()
  require "mappings"
end)
