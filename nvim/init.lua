vim.opt.colorcolumn = "120"
vim.wo.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.wrap = false
vim.o.linebreak = true
vim.o.termguicolors = true
vim.o.updatetime = 250
vim.o.signcolumn = "yes"
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() > 0 then
      vim.cmd("bwipeout 1")
    end
  end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "",
  callback = function()
    if vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) == "" then
      vim.bo.bufhidden = "wipe"
    end
  end,
})
vim.g.dashboard_default_executive = "telescope"
