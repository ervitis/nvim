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
keymap.set("n", "<M-w>", "<Plug>(VM-Add-Cursor-Down)", { desc = "Expand selection" })
keymap.set("n", "<M-W>", "<Plug>(VM-Add-Cursor-Up)", { desc = "Shrink selection" })
keymap.set("v", "<M-w>", "<Plug>(VM-Add-Cursor-Down)", { desc = "Expand selection" })
keymap.set("v", "<M-W>", "<Plug>(VM-Add-Cursor-Up)", { desc = "Shrink selection" })

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

-- splits
keymap.set("n", "<Leader>sv", ":vsplit<CR>", { desc = "Split vertically" })
keymap.set("n", "<Leader>sh", ":split<CR>", { desc = "Split horizontally" })
keymap.set("n", "<Leader>sc", ":close<CR>", { desc = "Close current split" })

keymap.set("n", "<M-h>", "<C-w>h", { desc = "Move to left split" })
keymap.set("n", "<M-j>", "<C-w>j", { desc = "Move to below split" })
keymap.set("n", "<M-k>", "<C-w>k", { desc = "Move to above split" })
keymap.set("n", "<M-l>", "<C-w>l", { desc = "Move to right split" })

keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease width" })
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase width" })
keymap.set("n", "<C-Up>", ":resize -2<CR>", { desc = "Decrease height" })
keymap.set("n", "<C-Down>", ":resize +2<CR>", { desc = "Increase height" })

keymap.set("n", "<Leader>se", "<C-w>=", { desc = "Make splits equal size" })

keymap.set("n", "<Leader>bn", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
keymap.set("n", "<Leader>bp", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
keymap.set("n", "<Leader>bc", ":BufferLinePickClose<CR>", { desc = "Close buffer" })

-- Navigate into methods using lsp
keymap.set("n", "<C-d>", vim.lsp.buf.definition, { desc = "Go to definition" })
keymap.set("n", "<C-D>", vim.lsp.buf.declaration, { desc = "Go to declaration" })
keymap.set("n", "<C-i>", vim.lsp.buf.implementation, { desc = "Go to implementation" })
keymap.set("n", "<C-r>", vim.lsp.buf.references, { desc = "Show references" })
keymap.set("n", "<C-p>", vim.lsp.buf.hover, { desc = "Peek definition" })
