-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- emulate jetbrains multicursor

-- move lines between

-- go to end of file
vim.keymap.set("n", "Y", "y$", { desc = "Yank to the end of the file" })

-- telescope buffers
vim.keymap.set("n", "<Leader>ts", "<cmd>Telescope buffers<cr>", { desc = "Show telescope buffers" })

-- show terminal buffer
vim.keymap.set("n", "<Leader>nt", "<cmd>terminal<cr>", { desc = "Show terminal buffer" })

-- show LazyGit
vim.keymap.set("n", "<Leader>lg", "<cmd>LazyGit<cr>", { desc = "Show LazyGit" })
