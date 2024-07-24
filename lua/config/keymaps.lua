-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

-- move lines or block between
keymap.set("n", "<M-Up>", ":m .-2<CR>==", { desc = "Move line up" })
keymap.set("n", "<M-Down>", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv", { desc = "Move block up" })
keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv", { desc = "Move block down" })

-- copy entire line
keymap.set("n", "<M-d>", ":t.<CR>", { desc = "Duplicate line" })
keymap.set("v", "<M-d>", ":t'><CR>gv", { desc = "Duplicate selection block" })

-- Expand or shrink selection using vim-expand-region
keymap.set("n", "<M-w>", "<Plug>(expand_region_expand)", { desc = "Expand selection" })
keymap.set("n", "<M-W>", "<Plug>(expand_region_shrink)", { desc = "Shrink selection" })

-- go to end of file
keymap.set("n", "Y", "y$", { desc = "Yank to the end of the file" })

-- telescope buffers
keymap.set("n", "<Leader>ts", "<cmd>Telescope buffers<cr>", { desc = "Show telescope buffers" })

-- show terminal buffer
keymap.set("n", "<Leader>nt", "<cmd>terminal<cr>", { desc = "Show terminal buffer" })

-- navigate between buffers
keymap.set("n", "<M-b>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap.set("n", "<M-v>", ":bnext<CR>", { desc = "Next buffer" })

-- show LazyGit
keymap.set("n", "<Leader>G", "<cmd>LazyGit<cr>", { desc = "Show LazyGit" })
