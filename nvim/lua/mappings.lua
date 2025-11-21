require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>s", ":sp<CR>", { desc = "Horizontal split" })
map("n", "<leader>vs", ":vsp<CR>", { desc = "Vertical split" })
map('n', "<leader>m", ":Markview toggle<CR>", { desc = "Toggle Markview" })
map("n", "<leader>=", ":resize +5<CR>", { desc = "Increase horizontal term height" })
map("n", "<leader>pa", ":echo expand('%:p')<CR>", { desc = "Print the current buffer's location" })

map("n", "<leader>e", "<cmd>Neotree focus<cr>", { desc = "Toggle Neo-tree" })
map("n", "<leader>o", "<cmd>Neotree toggle<cr>", { desc = "Focus Neo-tree" })

map("n", "<leader>ti", function()
  local ok = require("image").is_enabled()
  print("[image.nvim] status: " .. (ok and "ENABLED" or "DISABLED"))
end, { desc = "image.nvim status (ti)" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
