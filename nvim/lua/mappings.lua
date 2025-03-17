require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>s", ":sp<CR>", { desc = "Horizontal split" })
map("n", "<leader>vs", ":vsp<CR>", { desc = "Vertical split" })
map('n', "<leader>m", ":Markview toggle<CR>", { desc = "Toggle Markview" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
